import { action } from "@ember/object";
import { service } from "@ember/service";
import { apiInitializer } from "discourse/lib/api";
import PatronReplyButton from "../components/patron-reply-button.gjs";
import PatronTopicReplyButton from "../components/patron-topic-reply-button.gjs";

export default apiInitializer((api) => {
  const patronMembership = api.container.lookup("service:patron-membership");

  api.renderInOutlet(
    "topic-footer-main-buttons-before-create",
    PatronTopicReplyButton
  );

  api.modifyClass(
    "controller:topic",
    (Superclass) =>
      class extends Superclass {
        @service patronMembership;

        @action
        replyToPost(post) {
          const topic = post?.topic || this.model;

          if (
            topic?.archetype === "regular" &&
            !topic.closed &&
            !topic.archived &&
            !topic.deleted_at &&
            this.patronMembership.showIfRequired(topic.category_id)
          ) {
            return;
          }

          return super.replyToPost(...arguments);
        }
      }
  );

  api.registerValueTransformer(
    "can-create-topic-button",
    ({ value, context }) => {
      return patronMembership.shouldShowModal(context.category?.id) || value;
    }
  );

  api.registerBehaviorTransformer(
    "create-topic-button-click",
    ({ context, next }) => {
      if (patronMembership.showIfRequired(context.category?.id)) {
        return;
      }

      return next();
    }
  );

  api.registerValueTransformer("post-menu-buttons", ({ value, context }) => {
    const topic = context.post.topic;

    if (
      topic?.archetype === "regular" &&
      patronMembership.shouldShowModal(topic.category_id)
    ) {
      value.replace("reply", PatronReplyButton);
      context.collapsedButtons.show("reply");
    }

    return value;
  });
});
