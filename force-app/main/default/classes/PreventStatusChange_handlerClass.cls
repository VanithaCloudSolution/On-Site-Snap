/**
* @description       : Service Appointment Trigger
* @author            : vanitha R
* @group             : 
* @last modified on  : 03-05-2024
* @last modified by  : Vanitha R
* @last modified     : Date			By						Change
*                      03-05-2024	Vanitha R			     N/A				    
**/ 
public  class PreventStatusChange_handlerClass {
 public static void preventStatusChange(List<ServiceAppointment> newSA, Map<Id, ServiceAppointment> oldSA) {
        Set<Id> saIdsForCheck = new Set<Id>();

        for (ServiceAppointment saNew : newSA) {
            ServiceAppointment saOld = oldSA.get(saNew.Id);
            if (saNew.Status != 'None'&&saNew.Status != 'Scheduled' && saNew.Status != 'Canceled' && saNew.Status != saOld.Status ) {
                saIdsForCheck.add(saNew.Id);
            }
        }

        if (saIdsForCheck.isEmpty()) {
            return;
        }

        Map<Id, List<ContentDocumentLink>> saFilesMap = new Map<Id, List<ContentDocumentLink>>();
        for (ContentDocumentLink cdl : [
            SELECT Id, ContentDocument.Title, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :saIdsForCheck AND ShareType = 'V'
        ]) {
            if (!saFilesMap.containsKey(cdl.LinkedEntityId)) {
                saFilesMap.put(cdl.LinkedEntityId, new List<ContentDocumentLink>());
            }
            saFilesMap.get(cdl.LinkedEntityId).add(cdl);
        }

        for (ServiceAppointment sa : newSA) {
            if (!saIdsForCheck.contains(sa.Id)) {
                continue;
            }

            List<ContentDocumentLink> relatedFiles = saFilesMap.get(sa.Id);
            boolean fileRequirementMet = false;

            String expectedFileName = '';
            if (oldSA.containsKey(sa.Id)) {
                ServiceAppointment saOld = oldSA.get(sa.Id);
                expectedFileName = saOld.Status + '_' + sa.AppointmentNumber + '_' + sa.Status;
            }

            if (relatedFiles != null && !relatedFiles.isEmpty()) {
                for (ContentDocumentLink cdl : relatedFiles) {
                    if (cdl.ContentDocument.Title.contains(expectedFileName)) {
                        fileRequirementMet = true;
                        break;
                    }
                }
            }

            if (!fileRequirementMet) {
                sa.addError('You must upload a picture with a service appointment status "' + sa.status + '" before changing the status.'+'\n'+'Note:Upload Image Button Is Available On Service Appointment Action');

            }
        }
    }
}