%================================================================================
%  Base de conocimiento sobre la red Metro de la Ciudad de México...
%  
%  Dr. Salvador Godoy C. - agosto 2015
%  Última actualización: julio_2019
%================================================================================

%-----------------------------------------------------
% Parámetros globales
%  tiempos en segundos...
%-----------------------------------------------------
valor_parámetro(tiempo_inicial, 8).
valor_parámetro(tiempo_tramo, 5).
valor_parámetro(tiempo_transbordo, 10).
valor_parámetro(tiempo_final, 7).


transborde(el_rosario,2).
transborde(instituto_del_petróleo,4).
transborde(deportivo_18_de_marzo,4).
transborde(martín_carrera,2).
transborde(la_raza,4).
transborde(consulado,4).
transborde(tacuba,4).
transborde(guerrero,4).
transborde(garibaldi_lagunilla,3).
transborde(oceanía,4).
transborde(hidalgo,4).
transborde(bellas_artes,4).
transborde(morelos,4).
transborde(balderas,4).
transborde(salto_del_agua,4).
transborde(pino_suárez,4).
transborde(candelaria,4).
transborde(san_lázaro,4).
transborde(pantitlán,4).
transborde(tacubaya,5).
transborde(centro_médico,4).
transborde(chabacano,6).
transborde(jamaica,4).
transborde(santa_anita,3).
transborde(mixcoac,3).
transborde(zapata,4).
transborde(ermita,4).
transborde(atlatilco,4).

%-----------------------------------------------------
% Definición de las líneas...
%-----------------------------------------------------
color(línea_1, rosa).
color(línea_2, azul_marino).
color(línea_3, verde_olivo).
color(línea_4, azul_cielo).
color(línea_5, amarillo).
color(línea_6, rojo).
color(línea_7, naranja).
color(línea_8, verde_bandera).
color(línea_9, café).
color(línea_A, morado).
color(línea_B, gris_verde).
color(línea_12, dorado).

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
% Línea 1: Observatorio _ Pantitlán
%-----------------------------------------------------
sigue(observatorio, tacubaya, línea_1).
sigue(tacubaya, juanacatlán, línea_1).
sigue(juanacatlán, chapultepec, línea_1).
sigue(chapultepec, sevilla, línea_1).
sigue(sevilla, insurgentes, línea_1).
sigue(insurgentes, cuauhtémoc, línea_1).
sigue(cuauhtémoc, balderas, línea_1).
sigue(balderas, salto_del_agua, línea_1).
sigue(salto_del_agua, isabel_la_católica, línea_1).
sigue(isabel_la_católica, pino_suárez, línea_1).
sigue(pino_suárez, merced, línea_1).
sigue(merced, candelaria, línea_1).
sigue(candelaria, san_lázaro, línea_1).
sigue(san_lázaro, moctezuma, línea_1).
sigue(moctezuma, balbuena, línea_1).
sigue(balbuena, boulvd_puerto_aéreo, línea_1).
sigue(boulvd_puerto_aéreo, gómez_farías, línea_1).
sigue(gómez_farías, zaragoza, línea_1).
sigue(zaragoza, pantitlán, línea_1).

%-----------------------------------------------------
% Línea 2: Cuatro Caminos _  Tasqueña
%-----------------------------------------------------
sigue(cuatro_caminos, panteones, línea_2).
sigue(panteones, tacuba, línea_2).
sigue(tacuba, cuitláhuac, línea_2).
sigue(cuitláhuac, popotla, línea_2).
sigue(popotla, colegio_militar, línea_2).
sigue(colegio_militar, normal, línea_2).
sigue(normal, san_cosme, línea_2).
sigue(san_cosme, revolución, línea_2).
sigue(revolución, hidalgo, línea_2).
sigue(hidalgo, bellas_artes, línea_2).
sigue(bellas_artes, allende, línea_2).
sigue(allende, zócalo, línea_2).
sigue(zócalo, pino_suárez, línea_2).
sigue(pino_suárez, san_antonio_abad, línea_2).
sigue(san_antonio_abad, chabacano, línea_2).
sigue(chabacano, viaducto, línea_2).
sigue(viaducto, xola, línea_2).
sigue(xola, villa_de_cortés, línea_2).
sigue(villa_de_cortés, nativitas, línea_2).
sigue(nativitas, portales, línea_2).
sigue(portales, ermita, línea_2).
sigue(ermita, general_anaya, línea_2).
sigue(general_anaya, tasqueña, línea_2).

%-----------------------------------------------------
% Línea 3: Indios Verdes _ Universidad
%-----------------------------------------------------
sigue(indios_verdes, deportivo_18_de_marzo, línea_3).
sigue(deportivo_18_de_marzo, potrero, línea_3).
sigue(potrero, la_raza, línea_3).
sigue(la_raza, tlatelolco, línea_3).
sigue(tlatelolco, guerrero, línea_3).
sigue(guerrero, hidalgo, línea_3).
sigue(hidalgo, juárez, línea_3).
sigue(juárez, balderas, línea_3).
sigue(balderas, niños_héroes, línea_3).
sigue(niños_héroes, hospital_general, línea_3).
sigue(hospital_general, centro_médico, línea_3).
sigue(centro_médico, etiopía, línea_3).
sigue(etiopía, eugenia, línea_3).
sigue(eugenia, división_del_norte, línea_3).
sigue(división_del_norte, zapata, línea_3).
sigue(zapata, coyoacán, línea_3).
sigue(coyoacán, viveros, línea_3).
sigue(viveros, miguel_ángel_de_quevedo, línea_3).
sigue(miguel_ángel_de_quevedo, copilco, línea_3).
sigue(copilco, universidad, línea_3).

%-----------------------------------------------------
% Línea 4: Martín Carrera _ Santa Anita
%-----------------------------------------------------
sigue(martín_carrera, talismán, línea_4).
sigue(talismán, bondojito, línea_4).
sigue(bondojito, consulado, línea_4).
sigue(consulado, canal_del_norte, línea_4).
sigue(canal_del_norte, morelos, línea_4).
sigue(morelos, candelaria, línea_4).
sigue(candelaria, fray_servando, línea_4).
sigue(fray_servando, jamaica, línea_4).
sigue(jamaica, santa_anita, línea_4).

%-----------------------------------------------------
% Línea 5: Politécnico _ Pantitlán
%-----------------------------------------------------
sigue(politécnico, instituto_del_petróleo, línea_5).
sigue(instituto_del_petróleo, autobuses_del_norte, línea_5).
sigue(autobuses_del_norte, la_raza, línea_5).
sigue(la_raza, misterios, línea_5).
sigue(misterios, valle_gómez, línea_5).
sigue(valle_gómez, consulado, línea_5).
sigue(consulado, eduardo_molina, línea_5).
sigue(eduardo_molina, aragón, línea_5).
sigue(aragón, oceanía, línea_5).
sigue(oceanía, terminal_aérea, línea_5).
sigue(terminal_aérea, hangares, línea_5).
sigue(hangares, pantitlán, línea_5).

%-----------------------------------------------------
% Línea 6: El Rosario _ Martín Carrera
%-----------------------------------------------------
sigue(el_rosario, tezozómoc, línea_6).
sigue(tezozómoc, azcapotzalco, línea_6).
sigue(azcapotzalco, ferrería, línea_6).
sigue(ferrería, norte_45, línea_6).
sigue(norte_45, vallejo, línea_6).
sigue(vallejo, instituto_del_petróleo, línea_6).
sigue(instituto_del_petróleo, lindavista, línea_6).
sigue(lindavista, deportivo_18_de_marzo, línea_6).
sigue(deportivo_18_de_marzo, la_villa, línea_6).
sigue(la_villa, martín_carrera, línea_6).

%-----------------------------------------------------
% Línea 7: El Rosario _ Barranca del Muerto
%-----------------------------------------------------
sigue(el_rosario, aquiles_serdán, línea_7).
sigue(aquiles_serdán, camarones, línea_7).
sigue(camarones, refinería, línea_7).
sigue(refinería, tacuba, línea_7).
sigue(tacuba, san_joaquín, línea_7).
sigue(san_joaquín, polanco, línea_7).
sigue(polanco, auditorio, línea_7).
sigue(auditorio, constituyentes, línea_7).
sigue(constituyentes, tacubaya, línea_7).
sigue(tacubaya, san_pedro_de_los_pinos, línea_7).
sigue(san_pedro_de_los_pinos, san_antonio, línea_7).
sigue(san_antonio, mixcoac, línea_7).
sigue(mixcoac, barranca_del_muerto, línea_7).

%-----------------------------------------------------
% Línea 8: Garibaldi_Lagunilla _ Constitución de 1917
%-----------------------------------------------------
sigue(garibaldi_lagunilla, bellas_artes, línea_8).
sigue(bellas_artes, san_juan_de_letrán, línea_8).
sigue(san_juan_de_letrán, salto_del_agua, línea_8).
sigue(salto_del_agua,doctores, línea_8).
sigue(doctores, obrera, línea_8).
sigue(obrera, chabacano, línea_8).
sigue(chabacano, la_viga, línea_8).
sigue(la_viga, santa_anita, línea_8).
sigue(santa_anita, coyuya, línea_8).
sigue(coyuya, iztacalco, línea_8).
sigue(iztacalco, apatlaco, línea_8).
sigue(apatlaco, aculco, línea_8).
sigue(aculco, escuadrón_201, línea_8).
sigue(escuadrón_201, atlatilco, línea_8).
sigue(atlatilco, iztapalapa, línea_8).
sigue(iztapalapa, cerro_de_la_estrella, línea_8).
sigue(cerro_de_la_estrella, uam_1, línea_8).
sigue(uam_1, constitución_de_1917, línea_8).

%-----------------------------------------------------
% Línea 9: Tacubaya _ Pantitlán
%-----------------------------------------------------
sigue(tacubaya, patriotismo, línea_9).
sigue(patriotismo, chilpancingo, línea_9).
sigue(chilpancingo, centro_médico, línea_9).
sigue(centro_médico, lázaro_cárdenas, línea_9).
sigue(lázaro_cárdenas, chabacano, línea_9).
sigue(chabacano, jamaica, línea_9).
sigue(jamaica, mixiuhca, línea_9).
sigue(mixiuhca, velódromo, línea_9).
sigue(velódromo, ciudad_deportiva, línea_9).
sigue(ciudad_deportiva, puebla, línea_9).
sigue(puebla, pantitlán, línea_9).

%-----------------------------------------------------
% Línea A: Pantitlán _ La Paz
%-----------------------------------------------------
sigue(pantitlán, agrícola_oriental, línea_A).
sigue(agrícola_oriental, canal_de_san_juan, línea_A).
sigue(canal_de_san_juan, tepalcates, línea_A).
sigue(tepalcates, guelatao, línea_A).
sigue(guelatao, peñón_viejo, línea_A).
sigue(peñón_viejo, acatitla, línea_A).
sigue(acatitla, santa_marta, línea_A).
sigue(santa_marta, los_reyes, línea_A).
sigue(los_reyes, la_paz, línea_A).

%-----------------------------------------------------
% Línea B: Buenavista _ Ciudad Azteca
%-----------------------------------------------------
sigue(buenavista, guerrero, línea_B).
sigue(guerrero, garibaldi_lagunilla, línea_B).
sigue(garibaldi_lagunilla, lagunilla, línea_B).
sigue(lagunilla, tepito, línea_B).
sigue(tepito, morelos, línea_B).
sigue(morelos, san_lázaro, línea_B).
sigue(san_lázaro, flores_magón, línea_B).
sigue(flores_magón, romero_rubio, línea_B).
sigue(romero_rubio, oceanía, línea_B).
sigue(oceanía, deportivo_oceanía, línea_B).
sigue(deportivo_oceanía, bosque_de_aragón, línea_B).
sigue(bosque_de_aragón, villa_de_aragón, línea_B).
sigue(villa_de_aragón, nezahualcóyotl, línea_B).
sigue(nezahualcóyotl, impulsora, línea_B).
sigue(impulsora, río_de_los_remedios, línea_B).
sigue(río_de_los_remedios, múzquiz, línea_B).
sigue(múzquiz, ecatepec, línea_B).
sigue(ecatepec, olímpica, línea_B).
sigue(olímpica, plaza_aragón, línea_B).
sigue(plaza_aragón, ciudad_azteca, línea_B).

%============================================================
% OBSERVACIÓN:
%  No existen líneas 10 ni 11.  
%  Después de 9 siguen A y B y después sigue la línea 12...
%============================================================

%-----------------------------------------------------
% Línea 12: Mixcoac _ Tláhuac
%-----------------------------------------------------
sigue(mixcoac, insurgentes_sur, línea_12).
sigue(insurgentes_sur, hospital_20_de_noviembre, línea_12).
sigue(hospital_20_de_noviembre, zapata, línea_12).
sigue(zapata, parque_de_los_venados, línea_12).
sigue(parque_de_los_venados, eje_central, línea_12).
sigue(eje_central, ermita, línea_12).
sigue(ermita, mexicaltzingo, línea_12).
sigue(mexicaltzingo, atlatilco, línea_12).
sigue(atlatilco, culhuacán, línea_12).
sigue(culhuacán, san_andrés_tomatlán, línea_12).
sigue(san_andrés_tomatlán, lomas_estrella, línea_12).
sigue(lomas_estrella, calle_11, línea_12).
sigue(calle_11, periférico_oriente, línea_12).
sigue(periférico_oriente, tezonco, línea_12).
sigue(tezonco, olivos, línea_12).
sigue(olivos, nopalera, línea_12).
sigue(nopalera, zapotitlán, línea_12).
sigue(zapotitlán, tlaltenco, línea_12).
sigue(tlaltenco, tláhuac, línea_12).
