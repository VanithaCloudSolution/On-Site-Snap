/**
* @description       : 
* @author            : vanitha R
* @group             : 
* @last modified on  : 03-05-2024
* @last modified by  : Vanitha R
* @last modified     : Date			By						Change
*                      03-05-2024	Vanitha R			     N/A				    
**/ 
public with sharing class ServiceAppointmentImageUpload {
    
    @AuraEnabled(cacheable=true)
    public static String getSaStatus(Id parentId) {
        String saStatus = 'None';
        String appointmentIdentifier = '';
        if (parentId != null) {
            // Use the parentId if it's a ServiceAppointment Id
            ServiceAppointment saParent = [SELECT Id, Status FROM ServiceAppointment WHERE Id = :parentId LIMIT 1];
            if (saParent != null) {
                saStatus = saParent.Status;
            }
        }

        return saStatus;
    }
    @AuraEnabled(cacheable=true)
    public static String getSaStatusAppointmentNum(Id parentId) {
        String appointmentIdentifier = '';
        if (parentId != null) {
            // Use the parentId if it's a ServiceAppointment Id
            ServiceAppointment saParent = [SELECT Id,  AppointmentNumber FROM ServiceAppointment WHERE Id = :parentId LIMIT 1];
            if (saParent != null) {
                appointmentIdentifier = saParent.AppointmentNumber;
            }
        }

        return appointmentIdentifier;
    }
    //image upload process
    @AuraEnabled
    public static Id saveImage(String fileName, String base64Data, Id parentId, Id saId) {
       
      
        String saStatus = 'null';
        String appointmentIdentifier = '';
        if (saId != null) {
            ServiceAppointment sa = [SELECT Id, Status,AppointmentNumber  FROM ServiceAppointment WHERE Id = :saId LIMIT 1];
            saStatus = sa.Status;
            appointmentIdentifier = sa.AppointmentNumber;
        } else if (parentId != null) {
            // Use the parentId if it's a ServiceAppointment Id
            ServiceAppointment saParent = [SELECT Id, Status,AppointmentNumber FROM ServiceAppointment WHERE Id = :parentId LIMIT 1];
            if (saParent != null) {
                saId = saParent.Id;
                saStatus = saParent.Status;
                appointmentIdentifier = saParent.AppointmentNumber;
            }
        }

  // Modify the fileName based on the ServiceAppointment status
  if (saStatus != null && saId != null) {
    if(saStatus=='None'){
        fileName = saStatus + '_' + appointmentIdentifier + '_' + 'Scheduled_' + fileName;

    }
    if (saStatus == 'Scheduled') {
        fileName = saStatus + '_' + appointmentIdentifier + '_' + 'Dispatched_' + fileName;
    }  if (saStatus == 'Dispatched') {
        fileName = saStatus + '_' + appointmentIdentifier + '_' + 'In Progress_' + fileName;
    } 
   
}             
       
               base64Data = base64Data.substring(base64Data.indexOf(',') + 1);
               Blob fileData = EncodingUtil.base64Decode(base64Data);
       
               ContentVersion cv = new ContentVersion();
               cv.ContentLocation = 'S'; // S for Salesforce, E for External
               cv.PathOnClient = fileName;
               cv.VersionData = fileData;
               cv.FirstPublishLocationId = parentId; // This links the file directly to the service appointment record
               insert cv;
       
               return cv.Id;
       
    }
}