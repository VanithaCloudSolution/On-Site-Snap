import { LightningElement,track,api } from 'lwc';
import saveImage from '@salesforce/apex/ServiceAppointmentImageUpload.saveImage';
import getSaStatus from '@salesforce/apex/ServiceAppointmentImageUpload.getSaStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ImageUpload extends LightningElement {
    @api recordId; // Assuming this component is placed on a WorkOrder record page
    @track file;
    @track fileName;
    @track isInProgress = false;
    @track progressValue = '';
    progressOptions = [
        { label: 'Completed', value: 'Completed' },
        { label: 'Cannot Completed', value: 'Cannot Completed' }
    ];
     handleFilesChange(event) {
        this.file = event.target.files[0];
        this.fileName = this.file.name;
        this.saStatus = 'None';
    
        // Fetch Service Appointment status here
        // Assuming you have a method to fetch the status based on this.recordId
        // Replace getSaStatus with your actual method to fetch the status
        getSaStatus({ parentId: this.recordId })
            .then(result => {
                this.saStatus = result;
                if (this.saStatus == 'In Progress') {
                    this.isInProgress = true;
                } else {
                    this.isInProgress = false;
                }
            })
            .catch(error => {
                console.error('Error fetching Service Appointment status:', error);
            });
    }

    handleProgressChange(event) {
        this.progressValue = event.detail.value;
    }

    uploadFile() {
        if (this.file && this.progressValue) {
        if (this.file) {
            let reader = new FileReader();
            reader.onload = () => {
                let base64 = reader.result;
                
                
                if (this.isInProgress && this.progressValue) {
                    this.fileName = this.saStatus + '_' + this.recordId + '_' + this.progressValue + '_' + this.file.name;
                } 
                saveImage({ fileName: this.fileName, base64Data: base64, parentId: this.recordId }) 
                    .then(result => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Image uploaded successfully',
                                variant: 'success',
                            }),
                        );
                    })
                    .catch(error => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error uploading image',
                                message: error.body.message,
                                variant: 'error',
                            }),
                        );
                    });
            };
            reader.readAsDataURL(this.file);
        }
    }
        else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please select a file and choose a progress status.',
                    variant: 'error',
                }),
            );
        }
    
    }
}