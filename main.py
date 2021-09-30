from flask import Flask
from query import temporal_modelo
from query import reporteria

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "<h1>MIA - Practica 1</h1><p>Mario Josue Solis Solorzano - 201900629</p>"


@app.route("/cargarTemporal")
def cargarTemporal():
    return temporal_modelo.create_temporal()


@app.route("/eliminarTemporal")
def eliminarTemporal():
    return temporal_modelo.drop_temporal()


@app.route("/cargarModelo")
def cargarModelo():
    return temporal_modelo.create_modelo()


@app.route("/eliminarModelo")
def eliminarModelo():
    return temporal_modelo.drop_modelo()


@app.route("/counts")
def counts():
    return str(temporal_modelo.counts())


@app.route("/consulta1")
def consultan1():
    return reporteria.consultan(0)


@app.route("/consulta2")
def consulta2():
    return reporteria.consultan(1)


@app.route("/consulta3")
def consulta3():
    return reporteria.consultan(2)


@app.route("/consulta4")
def consulta4():
    return reporteria.consultan(3)


@app.route("/consulta5")
def consulta5():
    return reporteria.consultan(4)


@app.route("/consulta6")
def consulta6():
    return reporteria.consultan(5)


@app.route("/consulta7")
def consulta7():
    return reporteria.consultan(6)


@app.route("/consulta8")
def consulta8():
    return reporteria.consultan(7)


@app.route("/consulta9")
def consulta9():
    return reporteria.consultan(8)


@app.route("/consulta10")
def consulta10():
    return reporteria.consultan(9)


if __name__ == "__main__":
    app.run(debug=True)
