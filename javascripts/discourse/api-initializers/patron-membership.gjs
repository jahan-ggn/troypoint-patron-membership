import { apiInitializer } from "discourse/lib/api";
import PatronReplyButton from "../components/patron-reply-button.gjs";
import PatronTopicReplyButton from "../components/patron-topic-reply-button.gjs";

export default apiInitializer((api) => {
  const patronMembership = api.container.lookup("service:patron-membership");

  api.renderInOutlet(
    "topic-footer-main-buttons-before-create",
    PatronTopicReplyButton
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
