import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  const patronMembership = api.container.lookup("service:patron-membership");

  api.registerBehaviorTransformer(
    "create-topic-button-click",
    ({ context, next }) => {
      if (patronMembership.showIfRequired(context.category?.id)) {
        return;
      }

      return next();
    }
  );
});
