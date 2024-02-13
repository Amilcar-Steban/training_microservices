package com.aforo.kafka.consumer;

import com.aforo.dao.InvoiceDao;
import com.aforo.model.Invoice;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TransactionEvents {

    @Autowired
    private InvoiceDao _dao;

    @Autowired
    private ObjectMapper objectMapper;

    private Logger log = LoggerFactory.getLogger(TransactionEvents.class);

    public void processTransactionEvent(ConsumerRecord<Integer, String> consumerRecord) throws JsonProcessingException {
        Invoice event = objectMapper.readValue(consumerRecord.value(), Invoice.class);
        Invoice existingInvoice = _dao.findById(event.getIdInvoice()).orElse(null);

        if (existingInvoice != null) {

            // Actualizar el monto acumulando el nuevo monto al existente
            double currentAmount = existingInvoice.getAmount();
            double newAmount = event.getAmount();
            double updatedAmount = currentAmount - newAmount;
            existingInvoice.setAmount(updatedAmount);

            // Establecer el nuevo estado u otras actualizaciones si es necesario
            Integer state = updatedAmount < 0 ? 1 : 0;
            log.info("Cambio recibido: " + updatedAmount);
            existingInvoice.setState(state);

            log.info("Se ha pagado la factura #" + event.getIdInvoice() + ". Nuevo monto: " + updatedAmount);

            // Guardar la factura actualizada en la base de datos
            _dao.save(existingInvoice);
            
        } else {
            double amount = event.getAmount;
            Integer state = amount < 0 ? 1 : 0;
            event.setState(state);
            _dao.save(event);    
        }
        
    }
}
