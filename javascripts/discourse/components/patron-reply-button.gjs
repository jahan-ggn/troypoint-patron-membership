import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/ui-kit/d-button";
import dConcatClass from "discourse/ui-kit/helpers/d-concat-class";
import { i18n } from "discourse-i18n";

export default class PatronReplyButton extends Component {
  static delegateShouldRenderToTemplate = true;

  @service patronMembership;
  @service site;

  get shouldShow() {
    const post = this.args.post;
    const topic = post.topic;

    return (
      topic?.archetype === "regular" &&
      !topic.closed &&
      !topic.archived &&
      !topic.deleted_at &&
      !post.deleted_at &&
      post.post_type === 1 &&
      this.patronMembership.shouldShowModal(topic.category_id)
    );
  }

  get showLabel() {
    return (
      this.args.showLabel ??
      (this.site.desktopView && !this.args.state.isWikiMode)
    );
  }

  @action
  showMembershipModal() {
    this.patronMembership.showIfRequired(this.args.post.topic.category_id);
  }

  <template>
    {{#if this.shouldShow}}
      <DButton
        class={{dConcatClass
          "post-action-menu__reply"
          "reply"
          (if this.showLabel "create fade-out")
        }}
        ...attributes
        @action={{this.showMembershipModal}}
        @icon="reply"
        @label={{if this.showLabel "topic.reply.title"}}
        @title="post.controls.reply"
        @translatedAriaLabel={{i18n
          "post.sr_reply_to"
          post_number=@post.post_number
          username=@post.username
        }}
      />
    {{/if}}
  </template>
}
