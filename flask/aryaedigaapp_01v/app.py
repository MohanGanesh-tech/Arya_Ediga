from flask import Flask, render_template, request, redirect, url_for, session
import os

from flask.helpers import flash
import firebase_admin
from firebase_admin import credentials, firestore, auth, credentials 
from google.cloud import storage
import pyrebase
import json
from collections import Counter
from datetime import date

#==================== Firebase =================================
credential_path = "./aryaedigaapp-firebase.json"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path
client = storage.Client()
bucket = client.get_bucket('aryaedigaapp.appspot.com')

cred = credentials.Certificate("./aryaedigaapp-firebase.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

firebaseapikey = pyrebase.initialize_app(json.load(open('./fbconfig.json')))
firebaseapikey_auth = firebaseapikey.auth()
#=================== End Firebase ==============================

UPLOAD_FOLDER = './uploads/'
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.secret_key = "ayush"
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def index():
    return render_template("wemedia_login.html")

@app.route('/wemedia_signup')
def wemedia_signup():
    return render_template("wemedia_signup.html")

@app.route('/wemedialogin', methods=['POST'])
def wemedialogin():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        try:
            authobj = firebaseapikey_auth.sign_in_with_email_and_password(email, password)
            wid=authobj.get('localId')
            print(wid)
            doc = db.collection(u'wemedia_profile').document(wid).get()
            if doc.to_dict().get('account')=="active":
                session['wid']=wid
                return redirect('wemediahome')
            elif doc.to_dict().get('account')=="pending":
                flash('Your Account is Under Verification/Proccess')
                return redirect('/')
            else:
                flash('Something went wrong try again after some time')
                return redirect('/')
        except Exception as e:
            print(e)
            flash('Invalid Credentials')
            return redirect('/')
    return redirect('/')

@app.route('/wemedialogout')
def wemedialogout():
    session['wid'] = ""
    return redirect('/')

@app.route('/wemediasignup', methods=['Get','POST'])
def wemediasignup():
    if request.method == 'POST':
        name = request.form.get('name')
        profile_photo = request.files['profilephoto']
        email = request.form.get('email')
        phone = request.form.get('phone')
        password = request.form.get('password')

        try:
            profile_photo.save(os.path.join(app.config['UPLOAD_FOLDER'], profile_photo.filename))
            blob = bucket.blob('wemedia_profile/'+profile_photo.filename)
            blob.upload_from_filename('./uploads/'+profile_photo.filename)
            blob.make_public()
            print("your file url", blob.public_url)

            authobj = auth.create_user(email=email,password=password)
            print(authobj.uid)

            doc_ref = db.collection(u'wemedia_profile').document(authobj.uid)
            doc_ref.set({
                u'profile_name': name,
                u'profile_photo': blob.public_url,
                u'email': email,
                u'phone': phone,
                u'account': u'pending',
            })

            return redirect('/')
        except Exception as e:
            print(e)
            return {'message': 'Error creating user'},400

    return redirect('/')

@app.route('/wemediahome')
def wemediahome():
    wid = session.get('wid')
    doc = db.collection(u'wemedia_profile').document(wid).get()
    got = doc.to_dict()
    return render_template("wemedia_home.html",name=got.get('profile_name'))

@app.route('/wemediaprofile')
def wemediaprofile():
    wid = session.get('wid')
    doc = db.collection(u'wemedia_profile').document(wid).get()
    return render_template("wemedia_profile.html",profile=doc)

@app.route('/editwemediaprofile', methods=['Get','POST'])
def editwemediaprofile():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        phone = request.form.get('phone')
        profileid = request.form.get('profileid')

        doc_ref = db.collection(u'wemedia_profile').document(profileid)
        doc_ref.update({
            u'profile_name': name,
            # u'profile_photo': blob.public_url,
            u'email': email,
            u'phone': phone,
            u'account': u'active',
        })
    return redirect('/wemediaprofile')


@app.route('/postnews')
def postnews():
    return render_template("wemedia_postnews.html")

@app.route('/addpostnews', methods=['Get','POST'])
def addpostnews():
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        newsphoto = request.files['newsphoto']

        newsphoto.save(os.path.join(app.config['UPLOAD_FOLDER'], newsphoto.filename))
        blob = bucket.blob('wemedia_news/'+session.get('wid')+'/'+newsphoto.filename)
        blob.upload_from_filename('./uploads/'+newsphoto.filename)
        blob.make_public()
        print("your file url", blob.public_url)

        doc_ref = db.collection(u'wemedia_news').document()
        doc_ref.set({
            u'desc': description,
            u'photo': blob.public_url,
            u'title': title,
            u'status': u"active",
            u'published_date': firestore.SERVER_TIMESTAMP,
            u'wid': session.get('wid')
        })
    flash('Your News Post is Uploaded Succesfully')
    return redirect('/postnews')

@app.route('/viewnews')
def viewnews():
    wid = session.get('wid')
    docs = db.collection(u'wemedia_news').where(u'wid', u'==', wid).get()
    # for doc in docs:
    #     print(doc.id)
    return render_template("wemedia_viewnews.html",result=docs)

@app.route('/editnewspage/<newsid>')
def editnewspage(newsid):
    doc = db.collection(u'wemedia_news').document(newsid).get()
    return render_template("wemedia_editpost.html",news=doc)

@app.route('/editnews', methods=['Get','POST'])
def editnews():
    if request.method == 'POST':
        newsid = request.form.get('newsid')
        photostatus = request.form.get('photostatus')
        title = request.form.get('title')
        description = request.form.get('description')
        newsphoto = request.files['newsphoto']

        doc = db.collection(u'wemedia_news').document(newsid).get()
        if photostatus == "0":
            doc_ref = db.collection(u'wemedia_news').document(newsid)
            doc_ref.update({
                u'title': title,
                u'desc': description,
                u'published_date': firestore.SERVER_TIMESTAMP,
            })
        elif photostatus == "1":
            newsphoto.save(os.path.join(app.config['UPLOAD_FOLDER'], newsphoto.filename))
            blob = bucket.blob('wemedia_news/'+session.get('wid')+'/'+newsphoto.filename)
            blob.upload_from_filename('./uploads/'+newsphoto.filename)
            blob.make_public()
            print("your file url", blob.public_url)

            doc_ref = db.collection(u'wemedia_news').document(newsid)
            doc_ref.update({
                u'title': title,
                u'desc': description,
                u'photo': blob.public_url,
                u'published_date': firestore.SERVER_TIMESTAMP,
            })
        else:
            print("Something went wrong")
    return redirect('/viewnews')

@app.route('/deletenews/<newsid>')
def deletenews(newsid):
    doc = db.collection(u'wemedia_news').document(newsid).delete()
    return redirect('/viewnews')

@app.route('/postinfo', methods=['Get','POST'])
def postinfo():
    return render_template("wemedia_postinfo.html")

@app.route('/addpostinfo', methods=['Get','POST'])
def addpostinfo():
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')

        doc_ref = db.collection(u'student_view_info').document()
        doc_ref.set({
            u'desc': description,
            u'title': title,
            u'status': u"active",
            u'published_date': firestore.SERVER_TIMESTAMP,
            u'wid': session.get('wid')
        })
    flash('Your Info Post is Uploaded Succesfully')
    return redirect('/postinfo')

@app.route('/viewinfo')
def viewinfo():
    wid = session.get('wid')
    docs = db.collection(u'student_view_info').where(u'wid', u'==', wid).get()
    return render_template("wemedia_viewinfo.html",result=docs)

@app.route('/editinfopage/<newsid>')
def editinfopage(newsid):
    doc = db.collection(u'student_view_info').document(newsid).get()
    return render_template("wemedia_editinfo.html",news=doc)

@app.route('/editinfo', methods=['Get','POST'])
def editinfo():
    if request.method == 'POST':
        newsid = request.form.get('newsid')
        title = request.form.get('title')
        description = request.form.get('description')

        doc_ref = db.collection(u'student_view_info').document(newsid)
        doc_ref.update({
            u'title': title,
            u'desc': description,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
    return redirect('/viewinfo')

@app.route('/deleteinfo/<infoid>')
def deleteinfo(infoid):
    doc = db.collection(u'student_view_info').document(infoid).delete()
    return redirect('/viewinfo')

# =============================================================================================
# ========================================== Admin ============================================
# =============================================================================================

@app.route('/admin')
def admin():
    return render_template("admin_login.html")

@app.route('/adminlogout')
def adminlogout():
    session['aid'] = ""
    return redirect('/admin')

@app.route('/adminlogin', methods=['POST'])
def adminlogin():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        try:
            authobj = firebaseapikey_auth.sign_in_with_email_and_password(email, password)
            print(authobj.get('localId'))
            session['aid']=authobj.get('localId')

            return redirect('adminhome')
        except Exception as e:
            print(e)
            return redirect('/')
    return redirect('/')

@app.route('/adminhome')
def adminhome():
    aid = session.get('aid')
    doc = db.collection(u'admin_profile').document(aid).get()
    admin = doc.to_dict()

    feedbacks = db.collection(u'user_feedback').get()

    signupdates=[]
    men,women,girls,boys,invalid=0,0,0,0,0
    users = db.collection(u'user_profile').get()
    for u in users:
        oncreate_datetime = u.to_dict().get('createdOn')
        dob_datetime = u.to_dict().get('dob')
        signupdates.append("%s-%s-%s"%(oncreate_datetime.day,oncreate_datetime.month,oncreate_datetime.year))
        today = date.today()
        age = today.year - dob_datetime.year -((today.month, today.day) < (dob_datetime.month, dob_datetime.day))
        if(u.to_dict().get('gender') == "female" or u.to_dict().get('gender') == "Female"):
            if(age <= 18 and age >= 12):
                girls=girls+1
            else:
                women=women+1
        elif(u.to_dict().get('gender') == "male" or u.to_dict().get('gender') == "Male"):
            if(age <= 18 and age >= 12):
                boys=boys+1
            else:
                men=men+1
        else:
            invalid=invalid+1

    hosteldates=[]
    hostel_apps = db.collection(u'student_hostel_application').get()
    for h in hostel_apps:
        oncreate_datetime = h.to_dict().get('createdOn')
        dob_datetime = h.to_dict().get('dob')
        hosteldates.append("%s-%s-%s"%(oncreate_datetime.day,oncreate_datetime.month,oncreate_datetime.year))

    scholarshipdates=[]  
    scholarship_apps = db.collection(u'student_scholarship_application').get()
    for s in scholarship_apps:
        oncreate_datetime = s.to_dict().get('createdOn')
        dob_datetime = s.to_dict().get('dob')
        scholarshipdates.append("%s-%s-%s"%(oncreate_datetime.day,oncreate_datetime.month,oncreate_datetime.year))


    user_signups = dict(Counter(signupdates))
    demographics = {"women":women,"girls":girls,"men":men,"boys":boys,"invalid":invalid}
    hostel_applications = dict(Counter(hosteldates))
    scholarship_applications = dict(Counter(scholarshipdates))
    return render_template("admin_home.html",name=admin.get('profile_name'),feedbacks=feedbacks,users=json.dumps(user_signups),demographics=json.dumps(demographics),hostel_applications=json.dumps(hostel_applications),scholarship_applications=json.dumps(scholarship_applications))

@app.route('/posthostel')
def posthostel():
    return render_template("admin_posthostel.html")

@app.route('/addposthostel', methods=['Get','POST'])
def addposthostel():
    if request.method == 'POST':
        name = request.form.get('name')
        place = request.form.get('place')

        doc_ref = db.collection(u'student_hostel_list').document(name)
        doc_ref.set({
            u'place': place,
            u'name': name,
            u'published_date': firestore.SERVER_TIMESTAMP,
            u'status': "active",
            u'aid': session.get('aid')
        })
    flash('Hostel is Added Succesfully')
    return redirect('/posthostel')

@app.route('/viewhostel')
def viewhostel():
    aid = session.get('aid')
    docs = db.collection(u'student_hostel_list').where(u'aid', u'==', aid).get()
    return render_template("admin_viewhostel.html",result=docs)

@app.route('/postscholarship')
def postscholarship():
    return render_template("admin_postscholarship.html")

@app.route('/addpostscholarship', methods=['Get','POST'])
def addpostscholarship():
    if request.method == 'POST':
        desc = request.form.get('desc')
        title = request.form.get('title')
        start_date = request.form.get('start_date')
        last_date = request.form.get('last_date')

        doc_ref = db.collection(u'student_scholarship_types').document(title)
        doc_ref.set({
            u'desc': desc,
            u'title': title,
            u'published_date': firestore.SERVER_TIMESTAMP,
            u'status': "active",
            u'aid': session.get('aid'),
            u'start_date' : start_date,
            u'last_date': last_date
        })
    flash('Scholarship is Added Succesfully')
    return redirect('/postscholarship')

@app.route('/viewscholarship')
def viewscholarship():
    aid = session.get('aid')
    docs = db.collection(u'student_scholarship_types').where(u'aid', u'==', aid).get()
    return render_template("admin_viewscholarship.html",result=docs)


@app.route('/edithostelpage/<hostelid>')
def edithostelpage(hostelid):
    doc = db.collection(u'student_hostel_list').document(hostelid).get()
    return render_template("admin_edithostel.html",hostel=doc)

@app.route('/edithostel', methods=['Get','POST'])
def edithostel():
    if request.method == 'POST':
        hostelid = request.form.get('hostelid')
        name = request.form.get('name')
        place = request.form.get('place')

        doc_ref = db.collection(u'student_hostel_list').document(hostelid)
        doc_ref.update({
            u'name': name,
            u'place': place,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
    return redirect('/viewhostel')

@app.route('/deletehostel/<hostelid>')
def deletehostel(hostelid):
    doc = db.collection(u'student_hostel_list').document(hostelid).delete()
    return redirect('/viewhostel')

@app.route('/editscholarshippage/<scholarshipid>')
def editscholarshippage(scholarshipid):
    doc = db.collection(u'student_scholarship_types').document(scholarshipid).get()
    return render_template("admin_editscholarship.html",scholarship=doc)

@app.route('/editscholarship', methods=['Get','POST'])
def editscholarship():
    if request.method == 'POST':
        scholarshipid = request.form.get('scholarshipid')
        title = request.form.get('title')
        desc = request.form.get('desc')
        start_date = request.form.get('start_date')
        last_date = request.form.get('last_date')

        doc_ref = db.collection(u'student_scholarship_types').document(scholarshipid)
        doc_ref.update({
            u'title': title,
            u'desc': desc,
            u'published_date': firestore.SERVER_TIMESTAMP,
            u'start_date': start_date,
            u'last_date':last_date
        })
    return redirect('/viewscholarship')

@app.route('/deletescholarship/<scholarshipid>')
def deletescholarship(scholarshipid):
    doc = db.collection(u'student_scholarship_types').document(scholarshipid).delete()
    return redirect('/viewscholarship')

@app.route('/acceptedhostelapps')
def acceptedhostelapps():
    docs = db.collection(u'student_hostel_application').where(u'status', u'==', "active").get()
    return render_template("admin_acceptedhostelapps.html",result=docs)

@app.route('/pendinghostelapps')
def pendinghostelapps():
    docs = db.collection(u'student_hostel_application').where(u'status', u'==', "pending").get()
    return render_template("admin_pendinghostelapps.html",result=docs)

@app.route('/rejectedhostelapps')
def rejectedhostelapps():
    docs = db.collection(u'student_hostel_application').where(u'status', u'==', "blocked").get()
    return render_template("admin_rejectedhostelapps.html",result=docs)

@app.route('/activatehostelapp', methods=['Get','POST'])
def activatehostelapp():
    if request.method == 'POST':
        page = request.form.get('page')
        appid = request.form.get('accappid')
        print(page, appid)
        doc_ref = db.collection(u'student_hostel_application').document(appid)
        doc_ref.update({
            u'status': u"active",
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendinghostelapps')
        elif page == "active":
            return redirect('/acceptedhostelapps')
        elif page == "reject":
            return redirect('/rejectedhostelapps')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')

@app.route('/pendinghostelapp', methods=['Get','POST'])
def pendinghostelapp():
    if request.method == 'POST':
        page = request.form.get('page')
        appid = request.form.get('pendappid')
        reason = request.form.get('reason')
        print(page, appid, reason)
        doc_ref = db.collection(u'student_hostel_application').document(appid)
        doc_ref.update({
            u'status': u"pending",
            u'reason': reason,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendinghostelapps')
        elif page == "active":
            return redirect('/acceptedhostelapps')
        elif page == "reject":
            return redirect('/rejectedhostelapps')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')

@app.route('/rejecthostelapp', methods=['Get','POST'])
def rejecthostelapp():
    if request.method == 'POST':
        page = request.form.get('page')
        appid = request.form.get('rejappid')
        reason = request.form.get('reason')
        print(page, appid, reason)
        doc_ref = db.collection(u'student_hostel_application').document(appid)
        doc_ref.update({
            u'status': u"blocked",
            u'reason': reason,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendinghostelapps')
        elif page == "active":
            return redirect('/acceptedhostelapps')
        elif page == "reject":
            return redirect('/rejectedhostelapps')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')

@app.route('/acceptedscholarshipapps')
def acceptedscholarshipapps():
    docs = db.collection(u'student_scholarship_application').where(u'status', u'==', "active").get()
    return render_template("admin_acceptedscholarshipsapps.html",result=docs)  
    
@app.route('/pendingscholarshipapps')
def pendingscholarshipapps():
    docs = db.collection(u'student_scholarship_application').where(u'status', u'==', "pending").get()
    return render_template("admin_pendingscholarshipsapps.html",result=docs)    

@app.route('/rejectedscholarshipapps')
def rejectedscholarshipapps():
    docs = db.collection(u'student_scholarship_application').where(u'status', u'==', "blocked").get()
    return render_template("admin_rejectedscholarshipsapps.html",result=docs)    

@app.route('/activatescholarshipapp', methods=['Get','POST'])
def activatescholarshipapp():
    if request.method == 'POST':
        page = request.form.get('page')
        appid = request.form.get('accappid')
        amount = request.form.get('amount')
        print(page, appid, amount)
        doc_ref = db.collection(u'student_scholarship_application').document(appid)
        doc_ref.update({
            u'status': u"active",
            u'amount': amount,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendingscholarshipapps')
        elif page == "active":
            return redirect('/acceptedscholarshipapps')
        elif page == "reject":
            return redirect('/rejectedscholarshipapps')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')

@app.route('/pendingscholarshipapp', methods=['Get','POST'])
def pendingscholarshipapp():
    if request.method == 'POST':
        page = request.form.get('page')
        appid = request.form.get('pendappid')
        reason = request.form.get('reason')
        print(page, appid, reason)
        doc_ref = db.collection(u'student_scholarship_application').document(appid)
        doc_ref.update({
            u'status': u"pending",
            u'reason': reason,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendingscholarshipapps')
        elif page == "active":
            return redirect('/acceptedscholarshipapps')
        elif page == "reject":
            return redirect('/rejectedscholarshipapps')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')

@app.route('/rejectscholarshipapp', methods=['Get','POST'])
def rejectscholarshipapp():
    if request.method == 'POST':
        page = request.form.get('page')
        appid = request.form.get('rejappid')
        reason = request.form.get('reason')
        print(page, appid, reason)
        doc_ref = db.collection(u'student_scholarship_application').document(appid)
        doc_ref.update({
            u'status': u"blocked",
            u'reason': reason,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendingscholarshipapps')
        elif page == "active":
            return redirect('/acceptedscholarshipapps')
        elif page == "reject":
            return redirect('/rejectedscholarshipapps')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')


@app.route('/activeprofile')
def activeprofile():
    docs = db.collection(u'wemedia_profile').where(u'account', u'==', "active").get()
    return render_template("admin_wemedia_activeprofiles.html",result=docs) 

@app.route('/pendingprofile')
def pendingprofile():
    docs = db.collection(u'wemedia_profile').where(u'account', u'==', "pending").get()
    return render_template("admin_wemedia_pendingprofiles.html",result=docs) 

@app.route('/blockedprofile')
def blockedprofile():
    docs = db.collection(u'wemedia_profile').where(u'account', u'==', "blocked").get()
    return render_template("admin_wemedia_blockedprofiles.html",result=docs) 


@app.route('/activatewemideaprofile', methods=['Get','POST'])
def activatewemideaprofile():
    if request.method == 'POST':
        page = request.form.get('page')
        activateproid = request.form.get('activateproid')
        print(page, activateproid)
        doc_ref = db.collection(u'wemedia_profile').document(activateproid)
        doc_ref.update({
            u'account': u"active",
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendingprofile')
        elif page == "active":
            return redirect('/activeprofile')
        elif page == "block":
            return redirect('/blockedprofile')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')

@app.route('/pendingwemideaprofile', methods=['Get','POST'])
def pendingwemideaprofile():
    if request.method == 'POST':
        page = request.form.get('page')
        pendproid = request.form.get('pendproid')
        reason = request.form.get('reason')
        print(page, pendproid, reason)
        doc_ref = db.collection(u'wemedia_profile').document(pendproid)
        doc_ref.update({
            u'account': u"pending",
            u'reason': reason,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendingprofile')
        elif page == "active":
            return redirect('/activeprofile')
        elif page == "block":
            return redirect('/blockedprofile')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')

@app.route('/blockwemideaprofile', methods=['Get','POST'])
def blockwemideaprofile():
    if request.method == 'POST':
        page = request.form.get('page')
        blockproid = request.form.get('blockproid')
        reason = request.form.get('reason')
        print(page, blockproid, reason)
        doc_ref = db.collection(u'wemedia_profile').document(blockproid)
        doc_ref.update({
            u'account': u"blocked",
            u'reason': reason,
            u'published_date': firestore.SERVER_TIMESTAMP,
        })
        if page == "pending":
            return redirect('/pendingprofile')
        elif page == "active":
            return redirect('/activeprofile')
        elif page == "block":
            return redirect('/blockedprofile')
        else:
            return redirect('/adminhome')
    return redirect('/adminhome')