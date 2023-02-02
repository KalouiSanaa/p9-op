trigger OrderTrigger on Order(before update,after Update) {
    if(Trigger.isUpdate && Trigger.isBefore) {
        OrderTriggerHandler.handleOrderUpdates(Trigger.new);}
    if(Trigger.isUpdate && Trigger.isAfter) {
      OrderTriggerHandler.updateRevenueOnOrderStatusChange(Trigger.new, Trigger.old);
  }
}