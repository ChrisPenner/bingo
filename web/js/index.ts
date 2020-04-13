import { Elm } from '../../src/Main.elm'
import firebase from '@firebase/app'
import { UserCredential } from '@firebase/auth-types'
import { QuerySnapshot, DocumentSnapshot, DocumentReference, Transaction} from '@firebase/firestore-types'

// Imported for side effects
// import '@firebase/firestore'
// import '@firebase/auth'

// const fbApp = firebase.initializeApp({
//   apiKey: 'AIzaSyBI_jYegnxS3IHK2RzNVkbrdXW4zdylvaw',
//   authDomain: 'localhost',
//   projectId: 'bingo'
// });

// const db = fbApp.firestore()

function flattenCollection<T>(snapshot: QuerySnapshot<T>): T[] {
  return snapshot.docs.map(doc => doc.data());
}

async function init() {
  // const {user} : UserCredential = await firebase.auth().signInAnonymously();
  // if (user) {
  //   console.log(user)
  // } else {
  //   console.error("signed out")
  // }

  const elmApp = Elm.Main.init({
    node: document.getElementById('elm'),
    flags: {},
  });
};
init();

