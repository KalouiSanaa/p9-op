global class UpdateAccountRevenueBatchSchdulable  implements Schedulable {
        global void execute(SchedulableContext ctx) {
            UpdateAccountRevenueBatch updateAccountRevenus = new UpdateAccountRevenueBatch();
            Database.executeBatch(updateAccountRevenus);
        }
    }
