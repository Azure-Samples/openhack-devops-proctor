from flask import Flask, render_template, request, redirect, url_for, stream_with_context, Response, session, flash
from config import c_password, c_userid, c_script, c_tmpdir
import os
import subprocess

app = Flask(__name__)
app.secret_key = os.urandom(24)

@app.route('/')
def upload_a_file():
    if not session.get('logged_in'):
        return render_template('login.html')
    else:
        return render_template('upload.html')

@app.route('/login', methods=['POST'])
def do_admin_login():
    #
    ###
    ###### Ugh!!! Hard coded userid/password
    ###
    #
    if request.form['password'] == c_password and request.form['username'] == c_userid:
        session['logged_in'] = True
        return upload_a_file()
    else:
        session['logged_in'] = False
        return render_template('login.html')

@app.route("/logout")
def logout():
    session['logged_in'] = False
    return upload_a_file()

@app.route('/deploy', methods = ['GET', 'POST'])
def deploy():
    return render_template('deploy.html', value = session['filename'])

@app.route('/deployment', methods = ['GET', 'POST'])
def deployment():
    if request.method == 'POST':
        def generate():
            #
            # script execution assumes no parameters need to be passed to the bash script. 
            # Modify subprocess.Popen(..) if necessary
            # Each parameter is a separate entry inside []
            #
            script = c_tmpdir + c_script
            p=subprocess.Popen([script],
                stdout=subprocess.PIPE)
            for line in p.stdout:
                yield line.decode('utf-8') + '<br>'
        return Response(stream_with_context(generate()))   

@app.route('/uploader', methods = ['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        try:
            f = request.files['file']
            # need to add an appropriate temporary location/path
            fname = c_tmpdir + f.filename
            f.save(fname)
            session['filename']= fname
            return deploy()
        except:
            # user pressed upload w/o selecting a file first
            return upload_a_file()   
        return upload_a_file()       

		
if __name__ == '__main__':
    app.run(host='0.0.0.0')
