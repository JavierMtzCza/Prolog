%=========================================================================
% Javier Martínez Carranza  
%  
%   Examen parcial: Programar un "sistema de ayuda para usuarios del Sistema de Trasporte Colectivo Metro CdMx" 
%                   según las instrucciones de la presentación anexa...
%                       -Usar el conocimiento entregado sobre la red Metro CdMx...
%                       -No renombrar ningúna constante ni predicado...
%                       -Puede usar SWIPL o SWISH a su elección.
%                       -Programar los siguientes predicados:
%                           mejor_ruta(<estación1>,<estación2>, <mejor-ruta>, <tiempo>)
%                           peor_ruta(<estación1>,<estación2>, <peor-ruta>, <tiempo>)
%                           reporte_viaje(<estación1>,<estación2>)
%                       -El último predicado debe reportar, en consola, por cada tramo, los tiempos y movimientos del viaje solicitado...
%
%   Predicados relevantes:
%       mejor_ruta( +estación1, +estación2, -mejor-ruta, -tiempo).
%       peor_ruta( +estación1, +estación2, -peor-ruta, -tiempo).
%       reporte_viaje( +estación1, +estación2).
%=========================================================================

:- use_module(library(clpfd)).

%--------------- 
% calcular_rutas/3. Obtener todas las rutas Hamiltonianas con su respectivo tiempo para llegar de una estación a otra.
%     calcular_rutas( +estación1, +estación2, -<Ruta-Tiempo>).
%       
%       Explicación: Verdadero si <Ruta-Tiempo> es una ruta Hamiltoniana para llegar de <estación1> a <estación2>.
%                   Este predicado hace uso de viajar/5 de forma que sea mas fácil de usar para el usuario final.
%---------------
calcular_rutas(A,B,Ruta-Tiempo):-   viajar(A,B,[],[A,B],Ruta-Tiempo1), 
                                    valor_parámetro(tiempo_inicial, Tiempo_inicial),
                                    Tiempo is Tiempo1 + Tiempo_inicial - 10.

/*
viajar/5. Obtener rutas Hamiltonianas con su respectivo tiempo para llegar de una estación a otra.
viajar(+estación1, +estación2, +Memoria_de_lineas, +Memoria_de_estaciones,-<Ruta-Tiempo>).

        Explicación: Verdadero si <Ruta-Tiempo> es una ruta Hamiltoniana para llegar de <estación1> a <estación2>.
        Forma de uso: viajar(<estación1>,<estación2>,[],[estación1,estación2],Ruta-Tiempo) 
                    al usar el predicado la <Memoria_de_lineas> debe comenzar en con una lista vacía, esto hará que sume 10min de más por la  
                    naturaleza del algoritmo de manera que se deberá corregir este cálculo al momento de usarlo. De igual forma la 
                    <Memoria_de_estaciones> deberá contener la <estación1> y <estación2> para que no regrese una estación y vuelva a pasar por 
                    la <estación1> o la <estación2>.
*/
viajar(A,B,_,_,[A,B]-Tiempo):-  sigue(A,B,_),
                                valor_parámetro(tiempo_tramo, Tiempo_tramo), 
                                valor_parámetro(tiempo_final, Tiempo_final), 
                                ( transbordo(B,Grado) -> Tiempo#=(Tiempo_tramo*Grado)+Tiempo_final ; Tiempo#=(Tiempo_tramo*2)+Tiempo_final ).

viajar(A,B,Mem_lineas,Mem_estaciones,[A|Ruta]-Tiempo):- A \== B,sigue(A,Z,Linea),
                                                        \+member(Linea,Mem_lineas),
                                                        Z \== B,
                                                        \+member(Z,Mem_estaciones),
                                                        viajar(Z,B,[Linea|Mem_lineas],[Z|Mem_estaciones],Ruta-Suma),
                                                        valor_parámetro(tiempo_tramo, Tiempo_tramo),
                                                        valor_parámetro(tiempo_transbordo, Tiempo_transbordo),
                                                        ( transbordo(Z,Grado) -> 
                                                            Tiempo#=(Tiempo_tramo*Grado)+Tiempo_transbordo+Suma ; 
                                                            Tiempo#=(Tiempo_tramo*2)+Tiempo_transbordo+Suma 
                                                        ).

viajar(A,B,Mem_lineas,Mem_estaciones,[A|Ruta]-Tiempo):- A \== B,sigue(A,Z,Linea),
                                                        member(Linea,Mem_lineas),
                                                        Z \== B,
                                                        \+member(Z,Mem_estaciones),
                                                        viajar(Z,B,Mem_lineas,[Z|Mem_estaciones],Ruta-Suma),
                                                        valor_parámetro(tiempo_tramo, Tiempo_tramo),
                                                        ( transbordo(Z,Grado) -> 
                                                            Tiempo#=(Tiempo_tramo*Grado)+Suma ; 
                                                            Tiempo#=(Tiempo_tramo*2)+Suma 
                                                        ).

%--------------- 
% mejor_ruta/4. Obtener la ruta con el menor tiempo de traslado para llegar de una estación a otra.
%     mejor_ruta( +estación1, +estación2, -Ruta, -Tiempo).
%       
%       Explicación: Verdadero si <Ruta> es la mejor ruta Hamiltoniana con la cual se haga el menor <Tiempo> posible para llegar
%                   de la <estación1> a <estación2>.
%                   Este predicado hace uso de listar_tiempos/2 y en dado caso que se quiera observar toda la lista, descomentar el predicado
%                   print_term/2 que ha sido comentado para que reporte_viaje/2 quede lo mas limpio posible.
%---------------
mejor_ruta(A,B,Ruta,Tiempo):-   findall(Z-T,calcular_rutas(A,B,Z-T),Rutas),
                                listar_tiempos(Rutas,Tiempos),
                                min_list(Tiempos,Min),
                                once(nth1(Indice,Tiempos,Min)),
                                nth1(Indice,Rutas,Res),
                                Ruta-Tiempo=Res.
                                %print_term(Ruta,[]).
/*
listar_tiempos/2. Obtener una lista únicamente de los tiempos de las rutas encontradas.
listar_tiempos(+Rutas,-Tiempos).

        Explicación: Verdadero si <Tiempos> es una lista que contiene los tiempos de cada ruta dentro de <Rutas>.
                    La principal función de este predicado es obtener una lista de tiempos con la cual podamos comparar de forma fácil
                    todos los tiempos de las rutas encontradas.
*/
listar_tiempos([],[]).
listar_tiempos([_-T|Resto],[T|Tiempos]):- listar_tiempos(Resto,Tiempos).

%--------------- 
% peor_ruta/4. Obtener la ruta con el mayor tiempo de traslado para llegar de una estación a otra.
%     peor_ruta( +estación1, +estación2, -Ruta, -Tiempo).
%       
%       Explicación: Verdadero si <Ruta> es la peor ruta Hamiltoniana con la cual se haga el mayor <Tiempo> posible para llegar
%                   de la <estación1> a <estación2>.
%                   Este predicado hace uso de listar_tiempos/2 y en dado caso que se quiera observar toda la lista, descomentar el predicado
%                   print_term/2 que ha sido comentado para que reporte_viaje_simplificado/2 quede lo mas limpio posible.
%---------------
peor_ruta(A,B,Ruta,Tiempo):-findall(Z-T,calcular_rutas(A,B,Z-T),Rutas),
                            listar_tiempos(Rutas,Tiempos),
                            max_list(Tiempos,Max),
                            once(nth1(Indice,Tiempos,Max)),
                            nth1(Indice,Rutas,Res),
                            Ruta-Tiempo=Res.
                            %print_term(Ruta,[]).

%--------------- 
% reporte_viaje/2. Mostrar en pantalla el recorrido con tiempos de la mejor ruta para ir de una estación a otra.
%     reporte_viaje( +estación1, +estación2).
%       
%       Explicación: Verdadero si la impresión en pantalla muestra la mejor ruta para llegar de la <estación1> a la <estación2>.
%                   Este predicado hace uso de imprimir_ruta/2
%---------------
reporte_viaje(A,B):- once(mejor_ruta(A,B,Ruta,Tiempo)),
                    Horas #= Tiempo // 60,
                    Minutos #= Tiempo mod 60, 
                    format('~nTiempo total del viaje  ~t ~d ~30| minutos = ~d hora(s) y ~d minutos~n~n', [Tiempo,Horas,Minutos]),
                    valor_parámetro(tiempo_inicial, Tiempo_inicial),
                    format('Inicio: ~w, ~t ~d ~5| minutos~n~n',[A,Tiempo_inicial]),
                    imprimir_ruta(Ruta,1),
                    valor_parámetro(tiempo_final, Tiempo_final),
                    format('Final: ~w, ~t ~d ~5| minutos~n~n',[B,Tiempo_final]).

/*
imprimir_ruta/2. Imprimir la ruta en pantalla mostrando sus tiempos y, si es el caso, los trasbordos que debe tomar.
imprimir_ruta(+Ruta,+Tramo).

        Explicación: Verdadero si la impresión en pantalla muestra la mejor ruta para llegar de la <estación1> a la <estación2>.
        Forma de uso: imprimir_ruta(<Ruta>,1). <Tramo> ira incrementando al recorrer toda la ruta. 
*/
imprimir_ruta([X,Y],Tramo):-valor_parámetro(tiempo_tramo, Tiempo_tramo),
                            ( transbordo(Y,Grado)->
                                format('   Tramo ~d: ~w, ~w ~t ~d~5| minutos~n',[Tramo,X,Y,(Tiempo_tramo*Grado)]),
                                format('~t~5| Destino con grado ~d   sin transbordo~n~n',[Grado])    
                                ;
                                format('   Tramo ~d: ~w, ~w ~t ~d~5| minutos~n',[Tramo,X,Y,(Tiempo_tramo*2)]),
                                format('~t~5| Destino con grado 2 ~n~n')
                            ).
imprimir_ruta([X,Y,Z|Resto],Tramo):- sigue(X,Y,Línea1),sigue(Y,Z,Línea2), 
                                        Línea1 \== Línea2,
                                        transbordo(Y,Grado),
                                        valor_parámetro(tiempo_tramo, Tiempo_tramo), 
                                        format('   Tramo ~d: ~w, ~w ~t ~d~5| minutos~n',[Tramo,X,Y,(Tiempo_tramo*Grado)]),
                                        valor_parámetro(tiempo_transbordo,Tiempo_transbordo),
                                        format('~t~5| Destino con grado ~d   transbordo ~t~5|~d min~n~n',[Grado,Tiempo_transbordo]), 
                                        Tramo1 is Tramo+1,
                                        imprimir_ruta([Y,Z|Resto],Tramo1).
imprimir_ruta([X,Y,Z|Resto],Tramo):- sigue(X,Y,Línea1),sigue(Y,Z,Línea2), 
                                        Línea1 == Línea2,
                                        valor_parámetro(tiempo_tramo, Tiempo_tramo),
                                        ( transbordo(Y,Grado)->
                                            format('   Tramo ~d: ~w, ~w ~t ~d~5| minutos~n',[Tramo,X,Y,(Tiempo_tramo*Grado)]),
                                            format('~t~5| Destino con grado ~d   sin transbordo~n~n',[Grado])    
                                            ;
                                            format('   Tramo ~d: ~w, ~w ~t ~d~5| minutos~n',[Tramo,X,Y,(Tiempo_tramo*2)]),
                                            format('~t~5| Destino con grado 2 ~n~n')
                                        ),
                                        Tramo1 is Tramo+1,
                                        imprimir_ruta([Y,Z|Resto],Tramo1).

%--------------- 
% reporte_viaje_simplificado/2. Mostrar en pantalla el recorrido en lenguaje natural de la peor ruta para ir de una estación a otra.
%     reporte_viaje_simplificado( +estación1, +estación2).
%       
%       Explicación: Verdadero si la impresión en pantalla muestra la peor ruta para llegar de la <estación1> a la <estación2>.
%                   Este predicado hace uso de imprimir_ruta_simplificado/2
%---------------
reporte_viaje_simplificado(A,B):- peor_ruta(A,B,Ruta,_),
                                    nth1(2,Ruta,Segunda_estación),
                                    sigue(A,Segunda_estación,Línea),
                                    color(Línea,Color),
                                    format('~nTomar el metro en la estación ~w de la linea ~w ~n~n',[A,Color]),
                                    imprimir_ruta_simplificado(Ruta).

/*
imprimir_ruta_simplificado/2. Imprimir la ruta en pantalla en lenguaje natural.
imprimir_ruta_simplificado(+Ruta).

        Explicación: Verdadero si la impresión en pantalla muestra la peor ruta para llegar de la <estación1> a la <estación2>.
*/
imprimir_ruta_simplificado([_,Y]):-format('Finalmente llegamos al destino ~w ~n~n',[Y]).
imprimir_ruta_simplificado([X,Y,Z|Resto]):- sigue(X,Y,Línea1),sigue(Y,Z,Línea2), 
                                            Línea1 \== Línea2,
                                            color(Línea1,Color1),
                                            color(Línea2,Color2),
                                            format('   Seguir en la linea ~w hasta la estación ~w y transbordar a la linea ~w~n~n',[Color1,Y,Color2]),
                                            imprimir_ruta_simplificado([Y,Z|Resto]).
imprimir_ruta_simplificado([X,Y,Z|Resto]):- sigue(X,Y,Línea1),sigue(Y,Z,Línea2), 
                                            Línea1 == Línea2,
                                            imprimir_ruta_simplificado([Y,Z|Resto]).

/*
transbordo/2. Hecho con el cual podemos obtener el Grado de cada transbordo.
transbordo(Estación,Grado).
*/
transbordo(el_rosario,2).
transbordo(instituto_del_petróleo,4).
transbordo(deportivo_18_de_marzo,4).
transbordo(martín_carrera,2).
transbordo(la_raza,4).
transbordo(consulado,4).
transbordo(tacuba,4).
transbordo(guerrero,4).
transbordo(garibaldi_lagunilla,3).
transbordo(oceanía,4).
transbordo(hidalgo,4).
transbordo(bellas_artes,4).
transbordo(morelos,4).
transbordo(balderas,4).
transbordo(salto_del_agua,4).
transbordo(pino_suárez,4).
transbordo(candelaria,4).
transbordo(san_lázaro,4).
transbordo(pantitlán,4).
transbordo(tacubaya,5).
transbordo(centro_médico,4).
transbordo(chabacano,6).
transbordo(jamaica,4).
transbordo(santa_anita,3).
transbordo(mixcoac,3).
transbordo(zapata,4).
transbordo(ermita,4).
transbordo(atlatilco,4).

%-----------------------------------------------------
% Parámetros globales
%-----------------------------------------------------
valor_parámetro(tiempo_inicial, 8).
valor_parámetro(tiempo_tramo, 5).
valor_parámetro(tiempo_transbordo, 10).
valor_parámetro(tiempo_final, 7).

%-----------------------------------------------------
% Definición de las líneas...
%-----------------------------------------------------
color(línea_1, rosa).
color(línea_2, azul_marino).
color(línea_3, verde_olivo).
color(línea_4, azul_cielo).
color(línea_5, amarilla).
color(línea_6, roja).
color(línea_7, naranja).
color(línea_8, verde_bandera).
color(línea_9, café).
color(línea_A, morada).
color(línea_B, gris_verde).
color(línea_12, dorada).

trayecto(línea_1, observatorio, pantitlán).
trayecto(línea_1, cuatro_caminos, tasqueña).
trayecto(línea_3, indios_verdes, universidad).
trayecto(línea_4, martín_carrera, santa_anita).
trayecto(línea_5, politécnico, pantitlán).
trayecto(línea_6, el_rosario, martín_carrera).
trayecto(línea_7, el_rosario, barranca_del_muerto).
trayecto(línea_8, garibaldi_lagunilla, constitución_de_1917).
trayecto(línea_9, tacubaya, pantitlán).
trayecto(línea_A, pantitlán, la_paz).
trayecto(línea_B, buenavista, ciudad_azteca).
trayecto(línea_12, mixcoac, tláhuac).

%-----------------------------------------------------
% línea 1: Observatorio _ Pantitlán
%-----------------------------------------------------
sigue(observatorio, tacubaya, línea_1).
    sigue(tacubaya, observatorio, línea_1).
sigue(tacubaya, juanacatlán, línea_1).
    sigue(juanacatlán, tacubaya, línea_1).
sigue(juanacatlán, chapultepec, línea_1).
    sigue(chapultepec,juanacatlán, línea_1).
sigue(chapultepec, sevilla, línea_1).
    sigue(sevilla,chapultepec, línea_1).
sigue(sevilla, insurgentes, línea_1).
    sigue(insurgentes,sevilla, línea_1).
sigue(insurgentes, cuauhtémoc, línea_1).
    sigue(cuauhtémoc,insurgentes, línea_1).
sigue(cuauhtémoc, balderas, línea_1).
    sigue(balderas,cuauhtémoc, línea_1).
sigue(balderas, salto_del_agua, línea_1).
    sigue(salto_del_agua,balderas, línea_1).
sigue(salto_del_agua, isabel_la_católica, línea_1).
    sigue(isabel_la_católica,salto_del_agua, línea_1).
sigue(isabel_la_católica, pino_suárez, línea_1).
    sigue(pino_suárez, isabel_la_católica, línea_1).
sigue(pino_suárez, merced, línea_1).
    sigue(merced,pino_suárez, línea_1).
sigue(merced, candelaria, línea_1).
    sigue(candelaria, merced, línea_1).
sigue(candelaria, san_lázaro, línea_1).
    sigue(san_lázaro, candelaria, línea_1).
sigue(san_lázaro, moctezuma, línea_1).
    sigue(moctezuma,san_lázaro, línea_1).
sigue(moctezuma, balbuena, línea_1).
    sigue(balbuena,moctezuma, línea_1).
sigue(balbuena, boulvd_puerto_aéreo, línea_1).
    sigue(boulvd_puerto_aéreo,balbuena, línea_1).
sigue(boulvd_puerto_aéreo, gómez_farías, línea_1).
    sigue(gómez_farías,boulvd_puerto_aéreo, línea_1).
sigue(gómez_farías, zaragoza, línea_1).
    sigue(zaragoza,gómez_farías, línea_1).
sigue(zaragoza, pantitlán, línea_1).
    sigue(pantitlán,zaragoza, línea_1).

%-----------------------------------------------------
% Línea 2: Cuatro Caminos _  Tasqueña
%-----------------------------------------------------
sigue(cuatro_caminos, panteones, línea_2).
    sigue(panteones,cuatro_caminos, línea_2).
sigue(panteones, tacuba, línea_2).
    sigue(tacuba,panteones, línea_2).
sigue(tacuba, cuitláhuac, línea_2).
    sigue(cuitláhuac,tacuba, línea_2).
sigue(cuitláhuac, popotla, línea_2).
    sigue(popotla,cuitláhuac, línea_2).
sigue(popotla, colegio_militar, línea_2).
    sigue(colegio_militar,popotla, línea_2).
sigue(colegio_militar, normal, línea_2).
    sigue(normal,colegio_militar, línea_2).
sigue(normal, san_cosme, línea_2).
    sigue(san_cosme,normal, línea_2).
sigue(san_cosme, revolución, línea_2).
    sigue(revolución,san_cosme, línea_2).
sigue(revolución, hidalgo, línea_2).
    sigue(hidalgo,revolución, línea_2).
sigue(hidalgo, bellas_artes, línea_2).
    sigue(bellas_artes,hidalgo, línea_2).
sigue(bellas_artes, allende, línea_2).
    sigue(allende,bellas_artes, línea_2).
sigue(allende, zócalo, línea_2).
    sigue(zócalo,allende, línea_2).
sigue(zócalo, pino_suárez, línea_2).
    sigue(pino_suárez,zócalo, línea_2).
sigue(pino_suárez, san_antonio_abad, línea_2).
    sigue(san_antonio_abad,pino_suárez, línea_2).
sigue(san_antonio_abad, chabacano, línea_2).
    sigue(chabacano,san_antonio_abad, línea_2).
sigue(chabacano, viaducto, línea_2).
    sigue(viaducto,chabacano, línea_2).
sigue(viaducto, xola, línea_2).
    sigue(xola,viaducto, línea_2).
sigue(xola, villa_de_cortés, línea_2).
    sigue(villa_de_cortés,xola, línea_2).
sigue(villa_de_cortés, nativitas, línea_2).
    sigue(nativitas,villa_de_cortés, línea_2).
sigue(nativitas, portales, línea_2).
    sigue(portales,nativitas, línea_2).
sigue(portales, ermita, línea_2).
    sigue(ermita,portales, línea_2).
sigue(ermita, general_anaya, línea_2).
    sigue(general_anaya,ermita, línea_2).
sigue(general_anaya, tasqueña, línea_2).
    sigue(tasqueña,general_anaya, línea_2).

%-----------------------------------------------------
% Línea 3: Indios Verdes _ Universidad
%-----------------------------------------------------
sigue(indios_verdes, deportivo_18_de_marzo, línea_3).
    sigue(deportivo_18_de_marzo,indios_verdes, línea_3).
sigue(deportivo_18_de_marzo, potrero, línea_3).
    sigue(potrero,deportivo_18_de_marzo, línea_3).
sigue(potrero, la_raza, línea_3).
    sigue(la_raza,potrero, línea_3).
sigue(la_raza, tlatelolco, línea_3).
    sigue(tlatelolco,la_raza, línea_3).
sigue(tlatelolco, guerrero, línea_3).
    sigue(guerrero,tlatelolco, línea_3).
sigue(guerrero, hidalgo, línea_3).
    sigue(hidalgo,guerrero, línea_3).
sigue(hidalgo, juárez, línea_3).
    sigue(juárez,hidalgo, línea_3).
sigue(juárez, balderas, línea_3).
    sigue(balderas,juárez, línea_3).
sigue(balderas, niños_héroes, línea_3).
    sigue(niños_héroes,balderas, línea_3).
sigue(niños_héroes, hospital_general, línea_3).
    sigue(hospital_general,niños_héroes, línea_3).
sigue(hospital_general, centro_médico, línea_3).
    sigue(centro_médico,hospital_general, línea_3).
sigue(centro_médico, etiopía, línea_3).
    sigue(etiopía,centro_médico, línea_3).
sigue(etiopía, eugenia, línea_3).
    sigue(eugenia,etiopía, línea_3).
sigue(eugenia, división_del_norte, línea_3).
    sigue(división_del_norte,eugenia, línea_3).
sigue(división_del_norte, zapata, línea_3).
    sigue(zapata,división_del_norte, línea_3).
sigue(zapata, coyoacán, línea_3).
    sigue(coyoacán,zapata, línea_3).
sigue(coyoacán, viveros, línea_3).
    sigue(viveros,coyoacán, línea_3).
sigue(viveros, miguel_ángel_de_quevedo, línea_3).
    sigue(miguel_ángel_de_quevedo,viveros, línea_3).
sigue(miguel_ángel_de_quevedo, copilco, línea_3).
    sigue(copilco,miguel_ángel_de_quevedo, línea_3).
sigue(copilco, universidad, línea_3).
    sigue(universidad,copilco, línea_3).

%-----------------------------------------------------
% línea 4: Martín Carrera _ Santa Anita
%-----------------------------------------------------
sigue(martín_carrera, talismán, línea_4).
    sigue(talismán,martín_carrera, línea_4).
sigue(talismán, bondojito, línea_4).
    sigue(bondojito,talismán, línea_4).
sigue(bondojito, consulado, línea_4).
    sigue(consulado,bondojito, línea_4).
sigue(consulado, canal_del_norte, línea_4).
    sigue(canal_del_norte,consulado, línea_4).
sigue(canal_del_norte, morelos, línea_4).
    sigue(morelos,canal_del_norte, línea_4).
sigue(morelos, candelaria, línea_4).
    sigue(candelaria,morelos, línea_4).
sigue(candelaria, fray_servando, línea_4).
    sigue(fray_servando,candelaria, línea_4).
sigue(fray_servando, jamaica, línea_4).
    sigue(jamaica,fray_servando, línea_4).
sigue(jamaica, santa_anita, línea_4).
    sigue(santa_anita,jamaica, línea_4).

%-----------------------------------------------------
% Línea 5: Politécnico _ Pantitlán
%-----------------------------------------------------
sigue(politécnico, instituto_del_petróleo, línea_5).
    sigue(instituto_del_petróleo,politécnico, línea_5).
sigue(instituto_del_petróleo, autobuses_del_norte, línea_5).
    sigue(autobuses_del_norte,instituto_del_petróleo, línea_5).
sigue(autobuses_del_norte, la_raza, línea_5).
    sigue(la_raza,autobuses_del_norte, línea_5).
sigue(la_raza, misterios, línea_5).
    sigue(misterios,la_raza, línea_5).
sigue(misterios, valle_gómez, línea_5).
    sigue(valle_gómez,misterios, línea_5).
sigue(valle_gómez, consulado, línea_5).
    sigue(consulado,valle_gómez, línea_5).
sigue(consulado, eduardo_molina, línea_5).
    sigue(eduardo_molina,consulado, línea_5).
sigue(eduardo_molina, aragón, línea_5).
    sigue(aragón,eduardo_molina, línea_5).
sigue(aragón, oceanía, línea_5).
    sigue(oceanía,aragón, línea_5).
sigue(oceanía, terminal_aérea, línea_5).
    sigue(terminal_aérea,oceanía, línea_5).
sigue(terminal_aérea, hangares, línea_5).
    sigue(hangares,terminal_aérea, línea_5).
sigue(hangares, pantitlán, línea_5).
    sigue(pantitlán,hangares, línea_5).

%-----------------------------------------------------
% Línea 6: El Rosario _ Martín Carrera
%-----------------------------------------------------
sigue(el_rosario, tezozómoc, línea_6).
    sigue(tezozómoc,el_rosario, línea_6).
sigue(tezozómoc, azcapotzalco, línea_6).
    sigue(azcapotzalco,tezozómoc, línea_6).
sigue(azcapotzalco, ferrería, línea_6).
    sigue(ferrería,azcapotzalco, línea_6).
sigue(ferrería, norte_45, línea_6).
    sigue(norte_45,ferrería, línea_6).
sigue(norte_45, vallejo, línea_6).
    sigue(vallejo,norte_45, línea_6).
sigue(vallejo, instituto_del_petróleo, línea_6).
    sigue(instituto_del_petróleo,vallejo, línea_6).
sigue(instituto_del_petróleo, lindavista, línea_6).
    sigue(lindavista,instituto_del_petróleo, línea_6).
sigue(lindavista, deportivo_18_de_marzo, línea_6).
    sigue(deportivo_18_de_marzo,lindavista, línea_6).
sigue(deportivo_18_de_marzo, la_villa, línea_6).
    sigue(la_villa,deportivo_18_de_marzo, línea_6).
sigue(la_villa, martín_carrera, línea_6).
    sigue(martín_carrera,la_villa, línea_6).

%-----------------------------------------------------
% Línea 7: El Rosario _ Barranca del Muerto
%-----------------------------------------------------
sigue(el_rosario, aquiles_serdán, línea_7).
    sigue(aquiles_serdán,el_rosario, línea_7).
sigue(aquiles_serdán, camarones, línea_7).
    sigue(camarones,aquiles_serdán, línea_7).
sigue(camarones, refinería, línea_7).
    sigue(refinería,camarones, línea_7).
sigue(refinería, tacuba, línea_7).
    sigue(tacuba,refinería, línea_7).
sigue(tacuba, san_joaquín, línea_7).
    sigue(san_joaquín,tacuba, línea_7).
sigue(san_joaquín, polanco, línea_7).
    sigue(polanco,san_joaquín, línea_7).
sigue(polanco, auditorio, línea_7).
    sigue(auditorio,polanco, línea_7).
sigue(auditorio, constituyentes, línea_7).
    sigue(constituyentes,auditorio, línea_7).
sigue(constituyentes, tacubaya, línea_7).
    sigue(tacubaya,constituyentes, línea_7).
sigue(tacubaya, san_pedro_de_los_pinos, línea_7).
    sigue(san_pedro_de_los_pinos,tacubaya, línea_7).
sigue(san_pedro_de_los_pinos, san_antonio, línea_7).
    sigue(san_antonio,san_pedro_de_los_pinos, línea_7).
sigue(san_antonio, mixcoac, línea_7).
    sigue(mixcoac,san_antonio, línea_7).
sigue(mixcoac, barranca_del_muerto, línea_7).
    sigue(barranca_del_muerto,mixcoac, línea_7).

%-----------------------------------------------------
% línea 8: Garibaldi_Lagunilla _ Constitución de 1917
%-----------------------------------------------------
sigue(garibaldi_lagunilla, bellas_artes, línea_8).
    sigue(bellas_artes,garibaldi_lagunilla, línea_8).
sigue(bellas_artes, san_juan_de_letrán, línea_8).
    sigue(san_juan_de_letrán,bellas_artes, línea_8).
sigue(san_juan_de_letrán, salto_del_agua, línea_8).
    sigue(salto_del_agua,san_juan_de_letrán, línea_8).
sigue(salto_del_agua, doctores, línea_8).
    sigue(doctores,salto_del_agua, línea_8).
sigue(doctores, obrera, línea_8).
    sigue(obrera,doctores, línea_8).
sigue(obrera, chabacano, línea_8).
    sigue(chabacano,obrera, línea_8).
sigue(chabacano, la_viga, línea_8).
    sigue(la_viga,chabacano, línea_8).
sigue(la_viga, santa_anita, línea_8).
    sigue(santa_anita,la_viga, línea_8).
sigue(santa_anita, coyuya, línea_8).
    sigue(coyuya,santa_anita, línea_8).
sigue(coyuya, iztacalco, línea_8).
    sigue(iztacalco,coyuya, línea_8).
sigue(iztacalco, apatlaco, línea_8).
    sigue(apatlaco,iztacalco, línea_8).
sigue(apatlaco, aculco, línea_8).
    sigue(aculco,apatlaco, línea_8).
sigue(aculco, escuadrón_201, línea_8).
    sigue(escuadrón_201,aculco, línea_8).
sigue(escuadrón_201, atlatilco, línea_8).
    sigue(atlatilco,escuadrón_201, línea_8).
sigue(atlatilco, iztapalapa, línea_8).
    sigue(iztapalapa,atlatilco, línea_8).
sigue(iztapalapa, cerro_de_la_estrella, línea_8).
    sigue(cerro_de_la_estrella,iztapalapa, línea_8).
sigue(cerro_de_la_estrella, uam_1, línea_8).
    sigue(uam_1,cerro_de_la_estrella, línea_8).
sigue(uam_1, constitución_de_1917, línea_8).
    sigue(constitución_de_1917,uam_1, línea_8).

%-----------------------------------------------------
% Línea 9: Tacubaya _ Pantitlán
%-----------------------------------------------------
sigue(tacubaya, patriotismo, línea_9).
    sigue(patriotismo,tacubaya, línea_9).
sigue(patriotismo, chilpancingo, línea_9).
    sigue(chilpancingo,patriotismo, línea_9).
sigue(chilpancingo, centro_médico, línea_9).
    sigue(centro_médico,chilpancingo, línea_9).
sigue(centro_médico, lázaro_cárdenas, línea_9).
    sigue(lázaro_cárdenas,centro_médico, línea_9).
sigue(lázaro_cárdenas, chabacano, línea_9).
    sigue(chabacano,lázaro_cárdenas, línea_9).
sigue(chabacano, jamaica, línea_9).
    sigue(jamaica,chabacano, línea_9).
sigue(jamaica, mixiuhca, línea_9).
    sigue(mixiuhca,jamaica, línea_9).
sigue(mixiuhca, velódromo, línea_9).
    sigue(velódromo,mixiuhca, línea_9).
sigue(velódromo, ciudad_deportiva, línea_9).
    sigue(ciudad_deportiva,velódromo, línea_9).
sigue(ciudad_deportiva, puebla, línea_9).
    sigue(puebla,ciudad_deportiva, línea_9).
sigue(puebla, pantitlán, línea_9).
    sigue(pantitlán,puebla, línea_9).

%-----------------------------------------------------
% Línea A: Pantitlán _ La Paz
%-----------------------------------------------------
sigue(pantitlán, agrícola_oriental, línea_A).
    sigue(agrícola_oriental,pantitlán, línea_A).
sigue(agrícola_oriental, canal_de_san_juan, línea_A).
    sigue(canal_de_san_juan,agrícola_oriental, línea_A).
sigue(canal_de_san_juan, tepalcates, línea_A).
    sigue(tepalcates,canal_de_san_juan, línea_A).
sigue(tepalcates, guelatao, línea_A).
    sigue(guelatao,tepalcates, línea_A).
sigue(guelatao, peñón_viejo, línea_A).
    sigue(peñón_viejo,guelatao, línea_A).
sigue(peñón_viejo, acatitla, línea_A).
    sigue(acatitla,peñón_viejo, línea_A).
sigue(acatitla, santa_marta, línea_A).
    sigue(santa_marta,acatitla, línea_A).
sigue(santa_marta, los_reyes, línea_A).
    sigue(los_reyes,santa_marta, línea_A).
sigue(los_reyes, la_paz, línea_A).
    sigue(la_paz,los_reyes, línea_A).

%-----------------------------------------------------
% Línea B: Buenavista _ Ciudad Azteca
%-----------------------------------------------------
sigue(buenavista, guerrero, línea_B).
    sigue(guerrero,buenavista, línea_B).
sigue(guerrero, garibaldi_lagunilla, línea_B).
    sigue(garibaldi_lagunilla,guerrero, línea_B).
sigue(garibaldi_lagunilla, lagunilla, línea_B).
    sigue(lagunilla,garibaldi_lagunilla, línea_B).
sigue(lagunilla, tepito, línea_B).
    sigue(tepito,lagunilla, línea_B).
sigue(tepito, morelos, línea_B).
    sigue(morelos,tepito, línea_B).
sigue(morelos, san_lázaro, línea_B).
    sigue(san_lázaro,morelos, línea_B).
sigue(san_lázaro, flores_magón, línea_B).
    sigue(flores_magón,san_lázaro, línea_B).
sigue(flores_magón, romero_rubio, línea_B).
    sigue(romero_rubio,flores_magón, línea_B).
sigue(romero_rubio, oceanía, línea_B).
    sigue(oceanía,romero_rubio, línea_B).
sigue(oceanía, deportivo_oceanía, línea_B).
    sigue(deportivo_oceanía,oceanía, línea_B).
sigue(deportivo_oceanía, bosque_de_aragón, línea_B).
    sigue(bosque_de_aragón,deportivo_oceanía, línea_B).
sigue(bosque_de_aragón, villa_de_aragón, línea_B).
    sigue(villa_de_aragón,bosque_de_aragón, línea_B).
sigue(villa_de_aragón, nezahualcóyotl, línea_B).
    sigue(nezahualcóyotl,villa_de_aragón, línea_B).
sigue(nezahualcóyotl, impulsora, línea_B).
    sigue(impulsora,nezahualcóyotl, línea_B).
sigue(impulsora, río_de_los_remedios, línea_B).
    sigue(río_de_los_remedios,impulsora, línea_B).
sigue(río_de_los_remedios, múzquiz, línea_B).
    sigue(múzquiz,río_de_los_remedios, línea_B).
sigue(múzquiz, ecatepec, línea_B).
    sigue(ecatepec,múzquiz, línea_B).
sigue(ecatepec, olímpica, línea_B).
    sigue(olímpica,ecatepec, línea_B).
sigue(olímpica, plaza_aragón, línea_B).
    sigue(plaza_aragón,olímpica, línea_B).
sigue(plaza_aragón, ciudad_azteca, línea_B).
    sigue(ciudad_azteca,plaza_aragón, línea_B).

%-----------------------------------------------------
% Línea 12: Mixcoac _ Tláhuac
%-----------------------------------------------------
sigue(mixcoac, insurgentes_sur, línea_12).
    sigue(insurgentes_sur,mixcoac, línea_12).
sigue(insurgentes_sur, hospital_20_de_noviembre, línea_12).
    sigue(hospital_20_de_noviembre,insurgentes_sur, línea_12).
sigue(hospital_20_de_noviembre, zapata, línea_12).
    sigue(zapata,hospital_20_de_noviembre, línea_12).
sigue(zapata, parque_de_los_venados, línea_12).
    sigue(parque_de_los_venados,zapata, línea_12).
sigue(parque_de_los_venados, eje_central, línea_12).
    sigue(eje_central,parque_de_los_venados, línea_12).
sigue(eje_central, ermita, línea_12).
    sigue(ermita,eje_central, línea_12).
sigue(ermita, mexicaltzingo, línea_12).
    sigue(mexicaltzingo,ermita, línea_12).
sigue(mexicaltzingo, atlatilco, línea_12).
    sigue(atlatilco,mexicaltzingo, línea_12).
sigue(atlatilco, culhuacán, línea_12).
    sigue(culhuacán,atlatilco, línea_12).
sigue(culhuacán, san_andrés_tomatlán, línea_12).
    sigue(san_andrés_tomatlán,culhuacán, línea_12).
sigue(san_andrés_tomatlán, lomas_estrella, línea_12).
    sigue(lomas_estrella,san_andrés_tomatlán, línea_12).
sigue(lomas_estrella, calle_11, línea_12).
    sigue(calle_11,lomas_estrella, línea_12).
sigue(calle_11, periférico_oriente, línea_12).
    sigue(periférico_oriente,calle_11, línea_12).
sigue(periférico_oriente, tezonco, línea_12).
    sigue(tezonco,periférico_oriente, línea_12).
sigue(tezonco, olivos, línea_12).
    sigue(olivos,tezonco, línea_12).
sigue(olivos, nopalera, línea_12).
    sigue(nopalera,olivos, línea_12).
sigue(nopalera, zapotitlán, línea_12).
    sigue(zapotitlán,nopalera, línea_12).
sigue(zapotitlán, tlaltenco, línea_12).
    sigue(tlaltenco,zapotitlán, línea_12).
sigue(tlaltenco, tláhuac, línea_12).
    sigue(tláhuac,tlaltenco, línea_12).