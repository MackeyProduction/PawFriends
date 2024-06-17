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
      pets: a.hasMany('UserProfilePet', 'userProfileId'),
      watchLists: a.hasMany('WatchList', 'userProfileId'),
      advertisements: a.hasMany('UserProfileAdvertisement', 'userProfileId'),
      chats: a.hasMany('Chat', 'userProfileId')
    })
    .authorization((allow) => [allow.ownerDefinedIn('author')]),
  Pet: a
    .model({
      petId: a.id(),
      description: a.string(),
      name: a.string(),
      age: a.integer(),
      petImage: a.boolean(),
      currentPetType: a.hasOne('PetType', 'petTypeId'),
      currentPetBreed: a.hasOne('PetBreed', 'petBreedId'),
      userProfiles: a.hasMany('UserProfilePet', 'petId')
    })
    .authorization((allow) => [allow.guest()]),
  PetType: a
    .model({
      petTypeId: a.id(),
      description: a.string(),
      pet: a.belongsTo('Pet', 'petTypeId')
    })
    .authorization((allow) => [allow.guest()]),
  PetBreed: a
    .model({
      petBreedId: a.id(),
      description: a.string(),
      pet: a.belongsTo('Pet', 'petBreedId')
    })
    .authorization((allow) => [allow.guest()]),
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
    .authorization((allow) => [allow.ownerDefinedIn('author'), allow.ownerDefinedIn('recipient')]),
  Advertisement: a
    .model({
      advertisementId: a.id(),
      title: a.string(),
      releaseDate: a.datetime(),
      visitor: a.integer(),
      description: a.string(),
      advertisementImage: a.boolean(),
      tags: a.hasMany('AdvertisementTag', 'advertisementId'),
      watchLists: a.hasMany('WatchList', 'advertisementId'),
      userProfiles: a.hasMany('UserProfileAdvertisement', 'advertisementId'),
      chats: a.hasMany('Chat', 'advertisementId'),
    })
    .authorization((allow) => [allow.guest()]),
  Tag: a
    .model({
      tagId: a.id(),
      description: a.string(),
      userProfiles: a.hasMany('UserProfileTag', 'tagId'),
      advertisements: a.hasMany('AdvertisementTag', 'tagId')
    })
    .authorization((allow) => [allow.guest()]),
  UserProfileTag: a
    .model({
      userProfileId: a.id().required(),
      tagId: a.id().required(),
      userProfile: a.belongsTo('UserProfile', 'userProfileId'),
      tag: a.belongsTo('Tag', 'tagId')
    })
    .authorization((allow) => [allow.guest()]),
  AdvertisementTag: a
    .model({
      advertisementId: a.id().required(),
      tagId: a.id().required(),
      advertisement: a.belongsTo('Advertisement', 'advertisementId'),
      tag: a.belongsTo('Tag', 'tagId')
    })
    .authorization((allow) => [allow.guest()]),
  WatchList: a
    .model({
      userProfileId: a.id().required(),
      advertisementId: a.id().required(),
      userProfile: a.belongsTo('UserProfile', 'userProfileId'),
      advertisement: a.belongsTo('Advertisement', 'advertisementId')
    })
    .authorization((allow) => [allow.guest()]),
  UserProfilePet: a
    .model({
      userProfileId: a.id().required(),
      petId: a.id().required(),
      userProfile: a.belongsTo('UserProfile', 'userProfileId'),
      pet: a.belongsTo('Pet', 'petId')
    })
    .authorization((allow) => [allow.guest()]),
  UserProfileAdvertisement: a
    .model({
      userProfileId: a.id().required(),
      advertisementId: a.id().required(),
      userProfile: a.belongsTo('UserProfile', 'userProfileId'),
      advertisement: a.belongsTo('Advertisement', 'advertisementId')
    })
    .authorization((allow) => [allow.guest()]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'iam',
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
