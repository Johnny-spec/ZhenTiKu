// ?????????
import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

const FAV_STORE_NAME: string = 'fav_store';
const FAV_IDS_KEY: string = 'fav_ids';

export class FavoriteStore {
  private pref?: preferences.Preferences;
  private favIds: string[] = [];

  async init(context: common.Context): Promise<void> {
    this.pref = await preferences.getPreferences(context, FAV_STORE_NAME);
    await this.load();
  }

  async add(qid: string): Promise<void> {
    if (this.favIds.indexOf(qid) < 0) {
      this.favIds.push(qid);
      await this.save();
    }
  }

  async remove(qid: string): Promise<void> {
    const nextIds: string[] = this.favIds.filter((id: string) => id !== qid);
    if (nextIds.length !== this.favIds.length) {
      this.favIds = nextIds;
      await this.save();
    }
  }

  async isFav(qid: string): Promise<boolean> {
    return this.favIds.indexOf(qid) >= 0;
  }

  async list(): Promise<string[]> {
    return this.favIds.slice();
  }

  private async load(): Promise<void> {
    const pref: preferences.Preferences = this.ensureReady();
    const value: preferences.ValueType = await pref.get(FAV_IDS_KEY, '[]');
    if (typeof value === 'string') {
      try {
        const parsedIds: string[] = JSON.parse(value) as string[];
        this.favIds = parsedIds.filter((id: string) => typeof id === 'string' && id.length > 0);
      } catch (error) {
        this.favIds = [];
      }
    }
  }

  private async save(): Promise<void> {
    const pref: preferences.Preferences = this.ensureReady();
    await pref.put(FAV_IDS_KEY, JSON.stringify(this.favIds));
    await pref.flush();
  }

  private ensureReady(): preferences.Preferences {
    if (this.pref === undefined) {
      throw new Error('FavoriteStore??????????init(context)');
    }
    return this.pref;
  }
}

export const favoriteStore: FavoriteStore = new FavoriteStore();
