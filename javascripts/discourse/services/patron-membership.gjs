import Service, { service } from "@ember/service";
import PatronMembershipModal from "../components/modal/patron-membership";

export default class PatronMembershipService extends Service {
  @service currentUser;
  @service modal;

  shouldShowModal(categoryId) {
    if (
      !this.currentUser ||
      this.currentUser.staff ||
      settings.user_in_exempt_groups
    ) {
      return false;
    }

    const categoryIds = settings.categories
      .split("|")
      .filter(Boolean)
      .map(Number);

    return categoryIds.length === 0 || categoryIds.includes(Number(categoryId));
  }

  showIfRequired(categoryId) {
    if (!this.shouldShowModal(categoryId)) {
      return false;
    }

    this.modal.show(PatronMembershipModal);
    return true;
  }
}
