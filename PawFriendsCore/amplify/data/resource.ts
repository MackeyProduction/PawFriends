import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

/*== STEP 1 ===============================================================
The section below creates a Todo database table with a "content" field. Try
adding a new "isDone" field as a boolean. The authorization rule below
specifies that any unauthenticated user can "create", "read", "update", 
and "delete" any "Todo" records.
=========================================================================*/
const schema = a.schema({
  UserProfile: a
    .model({
      userProfileId: a.id(),
      description: a.string(),
      activeSince: a.date(),
      profileImage: a.boolean().default(false),
      location: a.string(),
      author: a.string(),
      tags: a.hasMany('UserProfileTag', 'userProfileId'),
      pets: a.hasMany('Pet', 'userProfileId'),
      watchLists: a.hasMany('WatchList', 'userProfileId'),
      advertisements: a.hasMany('Advertisement', 'userProfileId'),
      chats: a.hasMany('Chat', 'userProfileId'),
      follows: a.hasMany('UserProfileFollower', 'followerId'),
      followers: a.hasMany('UserProfileFollower', 'followedId')
    })
    .authorization((allow) => [allow.ownerDefinedIn('author').to(['create', 'read', 'update']), allow.authenticated().to(['create', 'read'])]),
  Pet: a
    .model({
      petId: a.id(),
      userProfileId: a.id(),
      description: a.string(),
      name: a.string(),
      age: a.integer(),
      petImage: a.boolean(),
      author: a.string(),
      petType: a.belongsTo('PetType', 'petId'),
      petBreed: a.belongsTo('PetBreed', 'petId'),
      userProfile: a.belongsTo('UserProfile', 'userProfileId')
    })
    .authorization((allow) => [allow.ownerDefinedIn('author'), allow.authenticated().to(['read'])]),
  PetType: a
    .model({
      petId: a.id(),
      description: a.string(),
      pets: a.hasMany('Pet', 'petId')
    })
    .authorization((allow) => [allow.owner().to(['read']), allow.authenticated().to(['read'])]),
  PetBreed: a
    .model({
      petId: a.id(),
      description: a.string(),
      pets: a.hasMany('Pet', 'petId')
    })
    .authorization((allow) => [allow.owner().to(['read']), allow.authenticated().to(['read'])]),
  Chat: a
    .model({
      message: a.string(),
      author: a.string(),
      recipient: a.string(),
      userProfileId: a.id().required(),
      advertisementId: a.id().required(),
      userProfile: a.belongsTo('UserProfile', 'userProfileId'),
      advertisement: a.belongsTo('Advertisement', 'advertisementId')
    })
    .authorization((allow) => [allow.ownerDefinedIn('author'), allow.ownerDefinedIn('recipient'), allow.authenticated().to(['read'])]),
  Advertisement: a
    .model({
      advertisementId: a.id(),
      userProfileId: a.id(),
      title: a.string(),
      releaseDate: a.datetime(),
      visitor: a.integer(),
      description: a.string(),
      advertisementImages: a.string().array(),
      author: a.string(),
      tags: a.hasMany('AdvertisementTag', 'advertisementId'),
      watchLists: a.hasMany('WatchList', 'advertisementId'),
      userProfile: a.belongsTo('UserProfile', 'userProfileId'),
      chats: a.hasMany('Chat', 'advertisementId'),
    })
    .authorization((allow) => [allow.ownerDefinedIn('author'), allow.authenticated().to(['read'])]),
  Tag: a
    .model({
      tagId: a.id(),
      description: a.string(),
      userProfiles: a.hasMany('UserProfileTag', 'tagId'),
      advertisements: a.hasMany('AdvertisementTag', 'tagId')
    })
    .authorization((allow) => [allow.owner().to(['read']), allow.authenticated().to(['read'])]),
  UserProfileTag: a
    .model({
      userProfileId: a.id().required(),
      tagId: a.id().required(),
      author: a.string(),
      userProfile: a.belongsTo('UserProfile', 'userProfileId'),
      tag: a.belongsTo('Tag', 'tagId')
    })
    .authorization((allow) => [allow.ownerDefinedIn('author'), allow.authenticated().to(['read'])]),
  AdvertisementTag: a
    .model({
      advertisementId: a.id().required(),
      tagId: a.id().required(),
      author: a.string(),
      advertisement: a.belongsTo('Advertisement', 'advertisementId'),
      tag: a.belongsTo('Tag', 'tagId')
    })
    .authorization((allow) => [allow.ownerDefinedIn('author'), allow.authenticated().to(['read'])]),
  WatchList: a
    .model({
      userProfileId: a.id().required(),
      advertisementId: a.id().required(),
      author: a.string(),
      userProfile: a.belongsTo('UserProfile', 'userProfileId'),
      advertisement: a.belongsTo('Advertisement', 'advertisementId')
    })
    .authorization((allow) => [allow.ownerDefinedIn('author'), allow.authenticated().to(['read'])]),
  UserProfileFollower: a
    .model({
      followerId: a.id().required(),
      followedId: a.id().required(),
      author: a.string(),
      follower: a.belongsTo('UserProfile', 'followerId'),
      followed: a.belongsTo('UserProfile', 'followedId')
    })
    .authorization((allow) => [allow.ownerDefinedIn('author'), allow.authenticated().to(['read'])]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'userPool',
  },
});

/*== STEP 2 ===============================================================
Go to your frontend source code. From your client-side code, generate a
Data client to make CRUDL requests to your table. (THIS SNIPPET WILL ONLY
WORK IN THE FRONTEND CODE FILE.)

Using JavaScript or Next.js React Server Components, Middleware, Server 
Actions or Pages Router? Review how to generate Data clients for those use
cases: https://docs.amplify.aws/gen2/build-a-backend/data/connect-to-API/
=========================================================================*/

/*
"use client"
import { generateClient } from "aws-amplify/data";
import type { Schema } from "@/amplify/data/resource";

const client = generateClient<Schema>() // use this Data client for CRUDL requests
*/

/*== STEP 3 ===============================================================
Fetch records from the database and use them in your frontend component.
(THIS SNIPPET WILL ONLY WORK IN THE FRONTEND CODE FILE.)
=========================================================================*/

/* For example, in a React component, you can use this snippet in your
  function's RETURN statement */
// const { data: todos } = await client.models.Todo.list()

// return <ul>{todos.map(todo => <li key={todo.id}>{todo.content}</li>)}</ul>
