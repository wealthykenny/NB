from flask import Flask, render_template, request, jsonify, session, redirect
import sqlite3

app = Flask(__name__)
app.secret_key = "nextbuy_vault_secure_key"

def get_db():
    conn = sqlite3.connect('nextbuy.db')
    conn.row_factory = sqlite3.Row
    return conn

# --- SECURITY DECORATOR ---
def is_official(user_id):
    db = get_db()
    user = db.execute('SELECT role FROM users WHERE id = ?', (user_id,)).fetchone()
    return user and user['role'] == 'official'

# --- ROUTES ---
@app.route('/')
def home():
    db = get_db()
    # Fetch all drops
    products = db.execute('SELECT * FROM products ORDER BY created_at DESC').fetchall()
    return render_template('index.html', products=products)

@app.route('/dashboard', methods=['GET', 'POST'])
def business_dashboard():
    # Only Nextbuy Official can access the BD
    if 'user_id' not in session or not is_official(session['user_id']):
        return "Access Denied. Nextbuy Official Personnel Only.", 403

    db = get_db()
    if request.method == 'POST':
        # Post a new drop
        title = request.form['title']
        price = request.form['price']
        img_url = request.form['img_url']
        db.execute('INSERT INTO products (title, price, image_url) VALUES (?, ?, ?)', 
                   (title, price, img_url))
        db.commit()
        return redirect('/dashboard')

    products = db.execute('SELECT * FROM products').fetchall()
    return render_template('dashboard.html', products=products)

@app.route('/api/toggle_action', methods=['POST'])
def toggle_action():
    if 'user_id' not in session:
        return jsonify({"error": "Unauthorized"}), 401
    
    data = request.json
    db = get_db()
    # Logic to insert/delete from likes_saves table based on action
    # ... (omitted for brevity, standard SQL toggle)
    return jsonify({"status": "Success", "action": data['action']})

if __name__ == '__main__':
    app.run(debug=True)
```

---
