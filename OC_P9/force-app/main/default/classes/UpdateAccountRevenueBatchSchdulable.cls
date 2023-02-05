//Cette classe vous permet de programmer la classe batch UpdateAccountRevenueBatch pour qu'elle s'exécute automatiquement selon un calendrier,
global class UpdateAccountRevenueBatchSchdulable  implements Schedulable {
        global void execute(SchedulableContext ctx) {
            // Crée une instance de la classe UpdateAccountRevenueBatch
            UpdateAccountRevenueBatch updateAccountRevenus = new UpdateAccountRevenueBatch();
           // Exécute la classe UpdateAccountRevenueBatch avec la méthode Database.executeBatch
            Database.executeBatch(updateAccountRevenus);
        }
    }
