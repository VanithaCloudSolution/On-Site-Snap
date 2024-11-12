/**
* @description       : Service Appointment Trigger
* @author            : vanitha R
* @group             : 
* @last modified on  : 03-05-2024
* @last modified by  : Vanitha R
* @last modified     : Date			By						Change
*                      03-05-2024	Vanitha R			     N/A				    
**/ 
trigger PreventSaStatusChangeWithoutFile_Trigger on ServiceAppointment (before update) {
  if (Trigger.isBefore && Trigger.isUpdate) {
        PreventStatusChange_handlerClass.preventStatusChange(Trigger.new, Trigger.oldMap);
    }

}