trigger OrderTrigger on Order(before update,after Update) {
   
  if (Trigger.isBefore) {
    OrderTriggerHandler.onBeforeUpdate(Trigger.new);
} else if (Trigger.isUpdate && Trigger.isAfter) {
    OrderTriggerHandler.onAfterUpdate(Trigger.new);
}
}