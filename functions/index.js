const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

// Quand un emprunt est créé
exports.onLoanCreate = functions.firestore
  .document('emprunts/{loanId}')
  .onCreate(async (snap) => {
    const loan = snap.data();
    const today = new Date().toISOString().substring(0,10); // yyyy-mm-dd

    // Stats livres empruntés
    const docRef = db.collection('stats').doc(`daily-${today}`);
    await docRef.set({
      total_loans: admin.firestore.FieldValue.increment(1),
      [`books.${loan.docId}`]: admin.firestore.FieldValue.increment(1)
    }, { merge: true });

    // Stats activité utilisateur
    await docRef.set({
      [`users.${loan.userId}`]: admin.firestore.FieldValue.increment(1)
    }, { merge: true });
});

// Quand un emprunt est mis à jour (retour effectué)
exports.onLoanUpdate = functions.firestore
  .document('emprunts/{loanId}')
  .onUpdate(async (change) => {
    const before = change.before.data();
    const after = change.after.data();

    // Si le livre est retourné
    if(before.status !== 'retourne' && after.status === 'retourne') {
      const dateRetourPrevue = after.dateRetourPrevue.toDate();
      const dateRetourReelle = after.dateRetourReelle.toDate();
      const retard = Math.max(0, (dateRetourReelle - dateRetourPrevue)/(1000*60*60*24));

      const today = new Date().toISOString().substring(0,10);
      const docRef = db.collection('stats').doc(`daily-${today}`);
      if(retard > 0){
        await docRef.set({
          total_retards: admin.firestore.FieldValue.increment(1)
        }, { merge: true });
      }
    }
});
