# On-Site Snap - Lightning Web Component

On-Site Snap is a custom Lightning Web Component (LWC) designed for Salesforce users to quickly capture and upload images or snapshots directly from their devices. This component is especially useful for on-site field technicians, allowing them to capture images relevant to service appointments, inspections, or documentation, and attach them to Salesforce records.
#### note: whenever the service appointment status is changed it won't allow the without taking or uploading the image.

# Features

- Snap and Upload: Allows users to take photos directly within Salesforce and upload them to relevant records (e.g., Work Orders, Service Appointments).
- Preview Image: After taking a snapshot, users can preview the image before uploading.
- Image Attachment: Captured images are saved as attachments to Salesforce records.
- Responsive: Optimized for both desktop and mobile devices.
- Customizable: Ability to customize the component for specific objects and use cases.

# Configuration

1. Add the Component to Lightning Pages:

- Open App Builder in your Salesforce org.
- Navigate to the desired record page (e.g., Work Order, Service Appointment).
- Drag and drop the On-Site Snap component onto the page layout.

2. Ensure User Permissions:

- Make sure the user profiles have permissions to access the necessary object records (e.g., Service Appointments, Work Orders).
- Ensure users have permission to add attachments to records.

3. Mobile Usage:

- The component is mobile-friendly and can be used in the Salesforce Mobile App for on-the-go field service operations.

4. Custom Object:

- If using a custom object or different fields for image attachments, make necessary adjustments to the component code.

# Usage
1. User Notified to upload image
   
   When service appointment status changes the trigger notify the users to upload image for particular service appointment status.
   
   ![image](https://github.com/user-attachments/assets/4e125ee7-b078-4372-a986-f26354f2dbe4)

4. Take a Snapshot:

- Click on the Take Snapshot button to open the camera interface or upload as file.
  
    ![image](https://github.com/user-attachments/assets/618508e2-5087-45eb-8749-ff23b05e2dae)

- Capture the image using the camera functionality of the device or upload as a accepted format file.


  ![image](https://github.com/user-attachments/assets/588811fe-2444-4f34-95ac-b86ef98f66ff)


3. Upload the Image:

After capturing and reviewing the image, click the Upload button to attach the image to the related Salesforce record (e.g., Service Appointment, Work Order).
Image Attachments:

![image](https://github.com/user-attachments/assets/ba6b9099-dad9-4299-9f3d-9bbe10862b83)


The uploaded image will be saved as an attachment to the Salesforce record, where it can be viewed or downloaded later.
