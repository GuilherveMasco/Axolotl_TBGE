import Foundation

class Cenas: Decodable{
  var cena: [Cena]?
  var cena_atual: Int?
  var objeto: [Objeto]?
  var inventario: [Int]?

  init(fileName : String){
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else { return }
    guard let data = try? Data(contentsOf: url) else { return }
    guard let jsonData = try? JSONDecoder().decode(Cenas.self, from: data) else { return }

    cena = jsonData.cena
    cena_atual = jsonData.cena_atual
    objeto = jsonData.objeto
    inventario = jsonData.inventario
  }
}

class Cena: Decodable{
  var key: Int
  var titulo: String
  var descricao: String
  var objetos: [Int]
}

class Objeto: Decodable{
  var id: Int
  var tipo: String
  var nome: String
  var descricao: String
  var resultado_positivo: String
  var resultado_negativo: String
  var comando_correto: String
  var cena_alvo: Int
  var resolvido: Int
  var obtido: Int
}

func ajuda(){
  print("---|| Lista de comandos ||---")
  print("HELP -> Abre lista de comandos")
  print("INVENTORY -> Lista seu inventário")
  print("USE <objeto> -> Usa/interage com objeto")
  print("USE <objeto> WITH <objeto> -> Usa/interage primeiro objeto com segundo")
  print("CHECK <objeto> -> Descreve informações do objeto")
  print("GET <objeto> -> Adiciona objeto ao inventário")
  print("\nPressione ENTER para retornar")
  if let comando = readLine() {
    return
  }
}

func game(){
  var cenas = Cenas(fileName: "dados")
  var cenaArray = cenas.cena!
  var objetoArray = cenas.objeto!
  var atual = cenas.cena_atual!
  var inv = cenas.inventario!

  system("clear")
  
  while(true){
    var flag = 0
    var objIds = cenaArray[atual].objetos
    print("---|| ", cenaArray[atual].titulo, " ||---")
    print("\n")
    print(cenaArray[atual].descricao)
    print("\nObjetos no local:")

    for i in objIds {
      var flagInv = 0
      
      if inv.contains(objetoArray[i].id){
        flagInv = 1
      }

      if flagInv == 0{
        print(objetoArray[i].nome)
      }
    }

    print("\n")

    //Leitura de entrada
    if var comando = readLine() {
      comando = comando.uppercased()
      var comandoArr = comando.components(separatedBy: " ")

      //Comando HELP
      if(comandoArr[0] == "HELP"){
        print("\n")
        ajuda()
        flag = 1
      }

      //Comando INVENTORY
      if comandoArr[0] == "INVENTORY"{
        print("\nInventário:")
        for i in inv {
          print(objetoArray[i].nome)
        }
        flag = 1
      }
    
      //Comando CHECK
      if comandoArr[0] == "CHECK"{
        var flagCheck = 0
        for i in objIds {
          if objetoArray[i].nome == comandoArr[1]{
            print("\n")
            print(objetoArray[i].descricao)
            flagCheck = 1
            break
          }
        }
        if flagCheck == 0 {
          print("\nNão localizei esse objeto")
        }
        flag = 1
      }

      //Comando USE
      var idObj = -1
      var flagObj = 0
      if comandoArr[0] == "USE"{
        var obj = comandoArr[1]
        for i in objIds {
          if objetoArray[i].nome == comandoArr[1]{
            idObj = objetoArray[i].id
            flagObj = 1
          }
        }
        if flagObj != 1{
          for j in inv {
            if objetoArray[j].nome == comandoArr[1] {
              idObj = objetoArray[j].id
              flagObj = 1
            }
          }
        }
        print("\n")
        if flagObj == 1 {
          if comando == objetoArray[idObj].comando_correto {
            print(objetoArray[idObj].resultado_positivo)
            atual = objetoArray[idObj].cena_alvo
          }
          else {
            print(objetoArray[idObj].resultado_negativo)
          }
        }
        else {
          print("Não consegui encontrar esse objeto\n")
        }
        flag = 1
      }

      //Comando GET
      idObj = -1
      flagObj = 0
      if comandoArr[0] == "GET"{
        var obj = comandoArr[1]
        for i in objIds {
          if objetoArray[i].nome == comandoArr[1]{
            idObj = objetoArray[i].id
            flagObj = 1
          }
        }

        print("\n")
        if flagObj == 1 {
          if objetoArray[idObj].tipo == "COLLECTABLE" {
            print(comandoArr[1], "coletado\n")
            inv.append(objetoArray[idObj].id)
          }
          else {
            print("Esse objeto não é coletável")
          }
        }
        else {
          print("Não consegui encontrar esse objeto\n")
        }
        flag = 1
      }
    
      //Comando NÃO RECONHECIDO
      if flag == 0{
        print("\nComando não reconhecido")
      }

      do{
        sleep(5)
      }
      system("clear")
    }
  }
}

game()