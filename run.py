from analysis.preprocess import LeetAnalysis
from flask import Flask, jsonify, request

app = Flask(__name__)
leet_analysis = LeetAnalysis()

@app.route('/')
def index():
    return "Welcome to the LeetAnalysis API!"

@app.route('/login', methods=['POST'])
def login():
    leet_analysis.login()
    return "Logged in successfully."

@app.route('/scrap_submissions', methods=['GET'])
def scrap_submissions():
    leet_analysis.scrap_submission_page()
    return "Scrapped submission page successfully."

@app.route('/scrap_each_page', methods=['GET'])
def scrap_each_page():
    leet_analysis.scrap_each_page()
    return "Scrapped each question page successfully."

@app.route('/create_dataframe', methods=['GET'])
def create_dataframe():
    leet_analysis.create_dataframe()
    return "DataFrame created successfully."

@app.route('/show_visuals', method = ['POST'])
def show_visuals():
    leet_analysis.show_visuals()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)


# with LeetAnalysis() as bot:
#     bot.load_df()
#     bot.land_first_page()
#     bot.login()
#     bot.scrap_submission_page()
#     bot.scrap_each_page()
#     bot.create_dataframe()
    # bot.show_visuals()