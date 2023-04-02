
import Data.List
import Data.Maybe
import System.IO



columnas = 50
filas = 30

cargar_Matriz :: [a] -> [[a]]
cargar_Matriz [] = []
cargar_Matriz xs = take 50 xs : cargar_Matriz (drop 50 xs)

dividir [] = []
dividir xs = take 50 xs : dividir (drop 50 xs)

tablero_inicial xs = zip [(x, y) | y <- [0..(filas - 1)], x <- [0..(columnas - 1)]] (map toInt (concat xs))
    where toInt '.' = 0
          toInt 'X' = 1

tablero_final tablero =   map fromInt (map snd (juego_de_la_vida (tablero)))
    where  fromInt 0 = '.'
           fromInt 1 = 'X'

juego_de_la_vida tablero = map evolucion tablero
    where evolucion ((x, y), estado_celula) = ((x, y), nuevo_estado)
              where nuevo_estado = if (estado_celula, vecinas_vivas) `elem` viva then 1 else 0
                    viva = [(0, 3), (1, 2), (1, 3)] 
                    vecinas_vivas = sum $ map estado_vecinas vecinas
                    estado_vecinas (x', y') = fromMaybe 0 $ lookup ((x' + x) `mod` columnas, (y' + y) `mod` filas) tablero
                    vecinas = [(x, y) | x <- [-1, 0, 1], y <- [-1, 0, 1], x /= 0 || y /= 0]

gameofLife xss 0 =  xss
gameofLife xss n = gameofLife (dividir(tablero_final( tablero_inicial(xss)))) (n-1)


--Diagonales--


vecinas_diagonales (x,y) = [(x+m,y+n) | m <- [-2,-1,1,2], n <- [-2,-1,1,2], abs m == abs n]

juego_de_la_vida_diagonales tablero = map evolucion tablero
    where evolucion ((x, y), estado_celula) = ((x, y), nuevo_estado)
              where nuevo_estado = if (estado_celula, vecinas_vivas) `elem` viva then 1 else 0
                    viva = [(0, 3), (1, 2), (1, 3)] 
                    vecinas_vivas = sum $ map estado_vecinas vecinas
                    estado_vecinas (x', y') = fromMaybe 0 $ lookup ((x' + x) `mod` columnas, (y' + y) `mod` filas) tablero
                    vecinas = vecinas_diagonales (x,y)

tablero_final_diagonales tablero = map fromInt (map snd (juego_de_la_vida_diagonales (tablero)))
    where  fromInt 0 = '.'
           fromInt 1 = 'X'

gameofLife_diagonales xss 0 =  xss
gameofLife_diagonales xss n = gameofLife_diagonales (dividir(tablero_final_diagonales( tablero_inicial(xss)))) (n-1)



--Filas y columnas--



vecinas_paralelas (x,y) = vecinas_verticales (x,y) ++ vecinas_horizontales (x,y)

vecinas_verticales (x,y) = [(x,y+n) | n <- [-2,-1,1,2]]
 
vecinas_horizontales (x,y) = [(x+m,y) | m <- [-2,-1,1,2]]

juego_de_la_vida_paralelas tablero = map evolucion tablero
    where evolucion ((x, y), estado_celula) = ((x, y), nuevo_estado)
              where nuevo_estado = if (estado_celula, vecinas_vivas) `elem` viva then 1 else 0
                    viva = [(0, 3), (1, 2), (1, 3)] 
                    vecinas_vivas = sum $ map estado_vecinas vecinas
                    estado_vecinas (x', y') = fromMaybe 0 $ lookup ((x' + x) `mod` columnas, (y' + y) `mod` filas) tablero
                    vecinas = vecinas_paralelas (x,y)

tablero_final_paralelas tablero = map fromInt (map snd (juego_de_la_vida_paralelas (tablero)))
    where  fromInt 0 = '.'
           fromInt 1 = 'X'

gameofLife_paralelas xss 0 =  xss
gameofLife_paralelas xss n = gameofLife_paralelas (dividir(tablero_final_paralelas(tablero_inicial(xss)))) (n-1)



--Juego--



leeInt :: IO Int
leeInt = do c <- getLine
            return (read c)

menu_Principal :: IO()
menu_Principal = do putStr "\n"
                    putStr "Las reglas del juego son las siguientes:"
                    putStr "\n"
                    putStr "  1. Si una célula está viva y tiene dos o tres vecinas vivas, entonces sigue viva"
                    putStr "\n"
                    putStr "  2. Si una célula está muerta y tiene tres vecinas vivas, nace"
                    putStr "\n"
                    putStr "  3. En cualquier otro caso, muere."
                    putStr "\n"
                    putStr "La siguiente generación nace de aplicar las reglas del juego a todas las células de manera simultánea."
                    putStr "\n"
                    putStr "\n"
                    putStr "1: Nueva Partida "
                    putStr "\n"
                    putStr "2: Cargar Partida "
                    putStr "\n"
                    putStr "3: Terminar "
                    putStr "\n"
                    opcion <- leeInt
                    case opcion of
                         1 -> do nueva_Partida
                         2 -> do cargar_Partida
                         3 -> do putStr "HASTA PRONTO"

nueva_Partida :: IO()
nueva_Partida  = do putStr "\n"
                    putStr "Has iniciado una nueva partida."
                    putStr "\n"
                    putStr "Debes elegir entre 4 modalidades distintas del juego:"
                    putStr "\n"
                    putStr "1: Juego Base."
                    putStr "\n"
                    putStr "2: Juego de las Diagonales."
                    putStr "\n"
                    putStr "3: Juego de las Filas y Columnas."
                    putStr "\n"
                    putStr "4: Abandonar Partida."
                    putStr "\n" 
                    verJuego <- leeInt
                    case verJuego of
                         1 -> do putStr "\n"
                                 putStr "Indica el tablero que quieres jugar"
                                 putStr "\n"
                                 putStr "1: Tablero1"
                                 putStr "\n"
                                 putStr "2: Tablero2"
                                 putStr "\n"
                                 putStr "3: Tablero3"
                                 putStr "\n"
                                 putStr "4: Tablero4"
                                 putStr "\n"
                                 opcion1 <- leeInt
                                 case opcion1 of
                                      1 -> do putStr "Has elegido el Tablero 1"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero1.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu1 <- leeInt
                                              case menu1 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      2 -> do putStr "Has elegido el Tablero 2"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero2.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu2 <- leeInt
                                              case menu2 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      3 -> do putStr "Has elegido el Tablero 3"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero3.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu3 <- leeInt
                                              case menu3 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      4 -> do putStr "Has elegido el Tablero 4"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero4.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu1 <- leeInt
                                              case menu1 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                         2 -> do putStr "\n"
                                 putStr "Has elegido el modo: Juego de las Diagonales"
                                 putStr "\n"
                                 putStr "Indica el tablero que quieres jugar"
                                 putStr "\n"
                                 putStr "1: Tablero 1"
                                 putStr "\n"
                                 putStr "2: Tablero 2"
                                 putStr "\n"
                                 putStr "3: Tablero 3"
                                 putStr "\n"
                                 putStr "4: Tablero 4"
                                 putStr "\n"
                                 opcion2 <- leeInt
                                 case opcion2 of
                                      1 -> do putStr "Has elegido el Tablero 1"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero1.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife_diagonales (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu1 <- leeInt
                                              case menu1 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife_diagonales (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      2 -> do putStr "Has elegido el Tablero 2"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero2.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife_diagonales (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu2 <- leeInt
                                              case menu2 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife_diagonales (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      3 -> do putStr "Has elegido el Tablero 3"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero3.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife_diagonales (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu3 <- leeInt
                                              case menu3 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife_diagonales (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      4 -> do putStr "Has elegido el Tablero 4"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero4.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife_diagonales (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu4 <- leeInt
                                              case menu4 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife_diagonales (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                         3 -> do putStr "\n"
                                 putStr "Has elegido el modo: Juego de las Filas y Columnas"
                                 putStr "\n"
                                 putStr "Indica el tablero que quieres jugar"
                                 putStr "\n"
                                 putStr "1: Tablero 1"
                                 putStr "\n"
                                 putStr "2: Tablero 2"
                                 putStr "\n"
                                 putStr "3: Tablero 3"
                                 putStr "\n"
                                 putStr "4: Tablero 4"
                                 putStr "\n"
                                 opcion3 <- leeInt
                                 case opcion3 of 
                                      1 -> do putStr "Has elegido el Tablero 1"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero1.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife_paralelas (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu1 <- leeInt
                                              case menu1 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife_paralelas (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      2 -> do putStr "Has elegido el Tablero 2"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero2.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife_paralelas (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu2 <- leeInt
                                              case menu2 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife_paralelas (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      3 -> do putStr "Has elegido el Tablero 3"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero3.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife_paralelas (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu3 <- leeInt
                                              case menu3 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife_paralelas (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                                      4 -> do putStr "Has elegido el Tablero 4"
                                              putStr "\n"
                                              putStr "\n"
                                              archivo <- openFile "tablero4.txt" ReadMode
                                              contenido <- hGetContents archivo
                                              mapM_ print (lines contenido)
                                              putStr "¿Cuántas iteraciones quieres hacer?"
                                              putStr "\n"
                                              iteraciones <- leeInt
                                              mapM_ print (gameofLife_paralelas (lines contenido) iteraciones)
                                              putStr "\n"
                                              putStr "A continuación, puedes: "
                                              putStr "\n"
                                              putStr " 1: Continuar con las iteraciones"
                                              putStr "\n"
                                              putStr " 2: Guardar el proceso."
                                              putStr "\n"
                                              putStr " 3: Salir sin guardar"
                                              putStr "\n"
                                              menu4 <- leeInt
                                              case menu4 of
                                                   1 -> do putStr "¿Cuántas iteraciones quieres hacer?"
                                                           putStr "\n"
                                                           iteraciones <- leeInt
                                                           mapM_ print (gameofLife_paralelas (lines contenido) iteraciones)
                                                           putStr "\n"
                                                   2 -> do mapM_ print (dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                                           let archivo = unlines(dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                                           putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                                           putStr "\n"
                                                           nombreguardar <- getLine
                                                           writeFile nombreguardar archivo
                                                   3 -> do nueva_Partida
                         4 -> do menu_Principal

cargar_Partida = do putStr "\n"
                    putStr "Dime el nombre del documento añadiendo la extentión .txt al final"
                    putStr "\n"
                    nombre <- getLine
                    contenido <- readFile nombre
                    mapM_ print (lines contenido)
                    putStr "Has cargado una partida"
                    putStr "\n"                  
                    putStr "Debes elegir entre 4 modalidades distintas del juego:"
                    putStr "\n"
                    putStr "1: Juego Base."
                    putStr "\n"
                    putStr "2: Juego de las Diagonales."
                    putStr "\n"
                    putStr "3: Juego de las Filas y Columnas."
                    putStr "\n"
                    putStr "4: Abandonar Partida."
                    putStr "\n"
                    opcion <- leeInt
                    case opcion of
                        1 -> do mapM_ print (dividir(tablero_final(tablero_inicial (lines contenido))))
                                let archivo = unlines(dividir(tablero_final(tablero_inicial (lines contenido))))
                                putStr "1: Guardar archivo"
                                putStr "\n"
                                putStr "2: Salir"
                                putStr "\n"
                                opcion1 <- leeInt
                                case opcion1 of
                                    1 -> do putStr "¿Cuántas iteraciones más quieres realizar?"
                                            putStr "\n"
                                            iteraciones <- leeInt
                                            mapM_ print(dividir(gameofLife (lines contenido) iteraciones))
                                            putStr "\n"
                                            putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                            putStr "\n"
                                            nombreguardar <- getLine
                                            writeFile nombreguardar archivo
                                    2 -> do menu_Principal
                        2 -> do mapM_ print (dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                let archivo = unlines(dividir(tablero_final_diagonales(tablero_inicial (lines contenido))))
                                putStr "1: Guardar archivo"
                                putStr "\n"
                                putStr "2: Salir"
                                putStr "\n"
                                opcion1 <- leeInt
                                case opcion1 of
                                    1 -> do putStr "¿Cuántas iteraciones más quieres realizar?"
                                            putStr "\n"
                                            iteraciones <- leeInt
                                            mapM_ print(dividir(gameofLife_diagonales (lines contenido) iteraciones))
                                            putStr "\n"
                                            putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                            putStr "\n"
                                            nombreguardar <- getLine
                                            writeFile nombreguardar archivo
                                    2 -> do menu_Principal
                        3 -> do mapM_ print (dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                let archivo = unlines(dividir(tablero_final_paralelas(tablero_inicial (lines contenido))))
                                putStr "1: Guardar archivo"
                                putStr "\n"
                                putStr "2: Salir"
                                putStr "\n"
                                opcion1 <- leeInt
                                case opcion1 of
                                    1 -> do putStr "¿Cuántas iteraciones más quieres realizar?"
                                            putStr "\n"
                                            iteraciones <- leeInt
                                            mapM_ print(dividir(gameofLife_paralelas (lines contenido) iteraciones))
                                            putStr "\n"
                                            putStr "Indique el nombre con el que quieres guardar el proceso añadiendo .txt al final"
                                            putStr "\n"
                                            nombreguardar <- getLine
                                            writeFile nombreguardar archivo
                                    2 -> do menu_Principal
                        4 -> do menu_Principal