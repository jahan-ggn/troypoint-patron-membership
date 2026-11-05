import Component from "@glimmer/component";
import DButton from "discourse/ui-kit/d-button";
import DModal from "discourse/ui-kit/d-modal";

export default class PatronMembershipModal extends Component {
  get settings() {
    return settings;
  }

  <template>
    <DModal
      class="patron-membership-modal"
      @closeModal={{@closeModal}}
      @title={{this.settings.modal_title}}
    >
      <:body>
        <p>{{this.settings.modal_message}}</p>
      </:body>

      <:footer>
        <DButton
          class="btn-primary"
          rel="noopener noreferrer"
          target="_blank"
          @href={{this.settings.redirect_url}}
          @translatedLabel={{this.settings.modal_button_label}}
        />

        <DButton class="btn-flat" @action={{@closeModal}} @label="close" />
      </:footer>
    </DModal>
  </template>
}
