import BackupExtensionAbility from '@ohos.application.BackupExtensionAbility';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN: number = 0x0000;
const TAG: string = 'EntryBackupAbility';

export default class EntryBackupAbility extends BackupExtensionAbility {
  async onBackup(): Promise<void> {
    hilog.info(DOMAIN, TAG, 'onBackup');
  }

  async onRestore(): Promise<void> {
    hilog.info(DOMAIN, TAG, 'onRestore');
  }
}
