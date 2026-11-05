import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/ui-kit/d-button";

export default class PatronTopicReplyButton extends Component {
  @service patronMembership;

  get topic() {
    return this.args.outletArgs.topic;
  }

  get shouldShow() {
    const topic = this.topic;

    return (
      topic?.archetype === "regular" &&
      !topic.closed &&
      !topic.archived &&
      !topic.deleted_at &&
      !topic.details?.can_create_post &&
      this.patronMembership.shouldShowModal(topic.category_id)
    );
  }

  @action
  showMembershipModal() {
    this.patronMembership.showIfRequired(this.topic.category_id);
  }

  <template>
    {{#if this.shouldShow}}
      <DButton
        class="btn-primary create topic-footer-button"
        @action={{this.showMembershipModal}}
        @icon="reply"
        @label="topic.reply.title"
        @title="topic.reply.help"
      />
    {{/if}}
  </template>
}
