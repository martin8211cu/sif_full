<cfif isdefined("url.btnMets")>

	<!--- Facts: Metricas --->

	<!--- Verificar que todos los datos se hayan acumulado --->
	<cfquery name="rsSQL" datasource="#DSNorigen#">
		select 	count(1) as cantidad
		  from	F_Datos
		 where	control < 3
	</cfquery>
	   <cfif rsSQL.cantidad GT 0>
		<cfthrow message="Se encontraron datos que requieren el proceso de calcular Acumulados">
	  </cfif>

	<!--- Elimina la información que se haya cargado anteriormente, de la que se haya modificado en el modelo relacional --->
	<cfquery name="rsSQL" datasource="#DSNorigen#">
		DELETE <cf_dbdatabase table="F_METRICA" datasource="#DSNdestino#">
		 WHERE  F_METRICA.ID_METRICA_DATOS in
				(	Select METRICA.ID_METRICA_DATOS
					  from F_Datos
					  inner join Empresas
						      on Empresas.Ecodigo = F_Datos.Ecodigo
                      inner join F_METRICA METRICA
                              on METRICA.ID_DATOS 		= F_Datos.id_datos
					         and METRICA.COD_FUENTE		= F_Datos.Ecodigo
					         and METRICA.COD_FUENTE_EMP	= Empresas.EcodigoSDC
					  where F_Datos.control = 3
					  <cfif NOT isdefined("URL.chkTodas")>
							and F_Datos.Ecodigo = #session.Ecodigo#
					  </cfif>
				)
	</cfquery>

	<!--- Ingresa datos de Metricas --->
	<cfquery datasource="#DSNorigen#">
		<!---
		Llenar la tabla de Hechos F_METRICAS desde el relacional.
		Obtiene la información desde la tabla relacional F_Datos que se debe ingresar en la Fact de F_METRICA.

		La llave primaria de la estructura F_METRICAS es el campo ID_DATOS.
		Para vincular la información del relacional con el dimensional se realiza por los siguientes campos:
			F_DATOS.ID_DATOS contra el campo F_METRICA.ID_DATOS
			F_DATOS.ECODIGO contra el campo F_METRICA.COD_FUENTE
			F_DATOS.ECODIGO contra el campo F_METRICA.COD_FUENTE_EMP
    --->
		Insert into F_METRICA (ID_DATOS, COD_FUENTE_EMP, COD_FUENTE, ID_PERIODO, ID_INDICADOR, ID_ESTRUCTURA_INF, ID_MONEDA, ID_PRODUCTO, ID_CUENTA, ID_ATR_DIM5, ID_ATR_DIM4, ID_ATR_DIM6, VALOR, META, ACUMULADO, ACUMULADO_META, VALOR_PERIODO_ANTERIOR, META_PERIODO_ANTERIOR, VALOR_ACUMULADO_PERIODO_ANT, VALOR_ANNO_ANTERIOR, META_ANNO_ANTERIOR, VALOR_ACUMULADO_ANNO_ANTERIOR, META_ACUMULADA_ANNO_ANTERIOR, META_ACUMULADA_PERIODO_ANT, FECHA_REGISTRO)
		Select F_Datos.id_datos,
			   Empresas.EcodigoSDC as COD_FUENTE_EMP, F_Datos.Ecodigo as COD_FUENTE,
			   PERIODO.ID_PERIODO, INDICADOR.ID_INDICADOR,
			   COALESCE(
							(
							select ESTRUCTURA_RPT.ID_ESTRUCTURA_INF
							  from Departamentos
							    inner join Empresas
			                        on Empresas.Ecodigo = Departamentos.Ecodigo
								inner join D_ESTRUCTURA_RPT ESTRUCTURA_RPT
									on rtrim(ESTRUCTURA_RPT.DEPARTAMENTO_CODIGO) = rtrim(Departamentos.Deptocodigo)
								   And ESTRUCTURA_RPT.COD_FUENTE                 = Departamentos.Ecodigo
								   And ESTRUCTURA_RPT.COD_FUENTE_EMP             = Empresas.EcodigoSDC
							 where Departamentos.Dcodigo = F_Datos.Dcodigo
							   And Departamentos.Ecodigo = F_Datos.Ecodigo
							)
						,-1) as ID_ESTRUCTURA_INF,
			   COALESCE(
							(
							select MONEDA.ID_MONEDA
							  from MIGMonedas
							    inner join Empresas
			                        on Empresas.Ecodigo = MIGMonedas.Ecodigo
								inner join D_MONEDA MONEDA
									on MONEDA.CODIGO_ISO_ALPHA = MIGMonedas.Mcodigo
								   And MONEDA.COD_FUENTE       = MIGMonedas.Ecodigo
								   And MONEDA.COD_FUENTE_EMP   = Empresas.EcodigoSDC
							 where MIGMonedas.Mcodigo = F_Datos.id_moneda
							 )
						,-1) as ID_MONEDA,
			   COALESCE(
							(
							select PRODUCTOS.ID_PRODUCTO
							  from MIGProductos
							    inner join Empresas
			                        on Empresas.Ecodigo = MIGProductos.Ecodigo
								inner join D_PRODUCTOS PRODUCTOS
									on rtrim(PRODUCTOS.PRODUCTO_CODIGO) = rtrim(MIGProductos.MIGProcodigo)
								   And PRODUCTOS.COD_FUENTE             = MIGProductos.Ecodigo
								   And PRODUCTOS.COD_FUENTE_EMP         = Empresas.EcodigoSDC
							 where MIGProductos.MIGProid = F_Datos.MIGProid
							)
						,-1) as ID_PRODUCTO,
			   COALESCE(
							(
							select CUENTAS.ID_CUENTA
							  from MIGCuentas
							    inner join Empresas
			                        on Empresas.Ecodigo = MIGCuentas.Ecodigo
								inner join <cf_dbdatabase table="D_CUENTAS" datasource="#DSNdestino#"> CUENTAS
									on rtrim(CUENTAS.CUENTA_CODIGO) = rtrim(MIGCuentas.MIGCuecodigo)
								   And CUENTAS.CODFUENTE            = MIGCuentas.Ecodigo
								   And CUENTAS.COD_FUENTE_EMP       = Empresas.EcodigoSDC
							 where MIGCuentas.MIGCueid = F_Datos.MIGCueid
							)
						,-1) as ID_CUENTA,

			   COALESCE(
							(
							select ID_ATR_DIM5.ID_CENTROS_TELEGESTION
							  from <cf_dbdatabase table="D_CENTROS_TELEGESTION" datasource="#DSNdestino#"> ID_ATR_DIM5
							 where rtrim(ID_ATR_DIM5.CODIGO_CENTRO_TELEGESTION) = rtrim(F_Datos.id_atr_dim5)
							   And ID_ATR_DIM5.CODFUENTE                        = F_Datos.Ecodigo
							)
						,-1) as ID_ATR_DIM5,

			   COALESCE(
							(
							select CENTRAL.ID_CENTRAL
							  from <cf_dbdatabase table="D_CENTRAL" datasource="#DSNdestino#"> CENTRAL
--							 where to_char(CENTRAL.CODIGO_CENTRAL) = rtrim(F_Datos.id_atr_dim4)
				             where <cf_dbfunction name="to_char" args="CENTRAL.CODIGO_CENTRAL"> = rtrim(F_Datos.id_atr_dim4)
							   And CENTRAL.CODFUENTE                                            = F_Datos.Ecodigo
							)
						,-1) as ID_ATR_DIM4,

			   COALESCE(
							(
							select GEOGRAFIA.ID_GEOGRAFIA
							  from <cf_dbdatabase table="D_GEOGRAFIA" datasource="#DSNdestino#"> GEOGRAFIA,
							       <cf_dbdatabase table="D_CENTRAL" datasource="#DSNdestino#">
							 where rtrim(GEOGRAFIA.CODIGO_DISTRITO_TELEFONICO) = rtrim(F_Datos.id_atr_dim6)
     						   And GEOGRAFIA.COD_FUENTE                        = F_Datos.Ecodigo
--							   and to_char(D_CENTRAL.CODIGO_CENTRAL)           = rtrim(F_Datos.id_atr_dim4)
                 			   and <cf_dbfunction name="to_char" args="D_CENTRAL.CODIGO_CENTRAL"> = rtrim(F_Datos.id_atr_dim4)
							   And GEOGRAFIA.ID_CENTRAL                        = D_CENTRAL.ID_CENTRAL
							)
						,-1) as ID_ATR_DIM6,

			   F_Datos.valor as VALOR, F_Datos.meta as META,
               Case when <cf_dbfunction name="sPart" args="MIGMetricas.MIGMcodigo,1,4"> = 'ACUM_' Then 0 Else F_Datos.acumulado End as ACUMULADO,
			   F_Datos.acumulado_meta as ACUMULADO_META,
			   F_Datos.valor_periodo_anterior as VALOR_PERIODO_ANTERIOR,
			   0 as META_PERIODO_ANTERIOR,
			   0 as VALOR_ACUMULADO_PERIODO_ANT,
			   F_Datos.valor_anno_anterior as VALOR_ANNO_ANTERIOR,
			   0 as META_ANNO_ANTERIOR,
			   F_Datos.valor_acumulado_anno_anterior as VALOR_ACUMULADO_ANNO_ANTERIOR,
			   0 as META_ACUMULADA_ANNO_ANTERIOR,
			   0 as META_ACUMULADA_PERIODO_ANT,
			   <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
		  from F_Datos
		 inner join Empresas
			 on Empresas.Ecodigo = F_Datos.Ecodigo
		 inner join <cf_dbdatabase table="D_PERIODO" datasource="#DSNdestino#"> PERIODO
			 on PERIODO.FECHA = F_Datos.Pfecha
		 inner join MIGMetricas
			 on MIGMetricas.MIGMid = F_Datos.MIGMid
		 inner join <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> INDICADOR
			 on INDICADOR.INDICADOR_CODIGO = MIGMetricas.MIGMcodigo
			And INDICADOR.COD_FUENTE       = MIGMetricas.Ecodigo
			And INDICADOR.COD_FUENTE_EMP   = Empresas.EcodigoSDC
		 where F_Datos.control = 3 --Valida los registros nuevos con los calculos de los acumulados
		<cfif NOT isdefined("URL.chkTodas")>
			and F_Datos.Ecodigo = #session.Ecodigo#
		</cfif>
	</cfquery>

	<cfquery datasource="#DSNorigen#">
		UPDATE  F_Datos
		   SET  control = 4
		 WHERE	F_Datos.control = 3
		  <cfif NOT isdefined("URL.chkTodas")>
				and F_Datos.Ecodigo = #session.Ecodigo#
		  </cfif>
	</cfquery>
<cfelse>


	<!--- Facts: Indicadores --->

	<!--- Verificar que todos los datos se hayan acumulado --->
	<cfquery name="rsSQL" datasource="#DSNorigen#">
		select 	count(1) as cantidad
		  from	F_Datos
		 where	control < 3
	     <cfif NOT isdefined("URL.chkTodas")>
			and F_Datos.Ecodigo = #session.Ecodigo#
	     </cfif>
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cfthrow message="Se encontraron datos que requieren el proceso de calcular Resumenes">
	</cfif>

	<!--- Borra la información en la Fact que se modificó en el modelo relacional --->
	<cfquery datasource="#DSNorigen#">
		DELETE FROM <cf_dbdatabase table="F_INDICADOR" datasource="#DSNdestino#">
		 WHERE ID_INDICADOR_DATOS IN (
					select INDICADORES.ID_INDICADOR_DATOS
					  from F_Resumen
						 inner join Empresas
						 on Empresas.Ecodigo = F_Resumen.Ecodigo
                         inner join <cf_dbdatabase table="D_PERIODO" datasource="#DSNdestino#"> PERIODOS
                                 on PERIODOS.FECHA = F_Resumen.Pfecha
                         inner join MIGMetricas
                                 on MIGMetricas.MIGMid = F_Resumen.MIGMid
                         inner join <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> INDICADOR
                                on INDICADOR.INDICADOR_CODIGO = MIGMetricas.MIGMcodigo
                               And INDICADOR.COD_FUENTE       = MIGMetricas.Ecodigo
                               And INDICADOR.COD_FUENTE_EMP   = Empresas.EcodigoSDC
<!--- Se comenta para no comparar por el detalle del indicador, sólo por indicador y período
                         inner join Departamentos
                                 on Departamentos.Dcodigo = F_Resumen.Dcodigo
                                And Departamentos.Ecodigo = F_Resumen.Ecodigo
                         inner join <cf_dbdatabase table="D_ESTRUCTURA_RPT" datasource="#DSNdestino#"> ESTRUCTURA_RPT
                                 on rtrim(ESTRUCTURA_RPT.DEPARTAMENTO_CODIGO) = rtrim(Departamentos.Deptocodigo)
                                And ESTRUCTURA_RPT.COD_FUENTE          = Departamentos.Ecodigo
                                And ESTRUCTURA_RPT.COD_FUENTE_EMP      = Empresas.EcodigoSDC
                         left join MIGProductos
                                on MIGProductos.MIGProid = F_Resumen.MIGProid
                         left join <cf_dbdatabase table="D_PRODUCTOS" datasource="#DSNdestino#"> PRODUCTOS
                                on PRODUCTOS.PRODUCTO_CODIGO = MIGProductos.MIGProcodigo
                               And PRODUCTOS.COD_FUENTE      = MIGProductos.Ecodigo
                               And PRODUCTOS.COD_FUENTE_EMP  = Empresas.EcodigoSDC
                         left join MIGCuentas
                                on MIGCuentas.MIGCueid = F_Resumen.MIGCueid
                         left join <cf_dbdatabase table="D_CUENTAS" datasource="#DSNdestino#"> CUENTAS
                                on CUENTAS.CUENTA_CODIGO  = MIGCuentas.MIGCuecodigo
                               And CUENTAS.CODFUENTE      = MIGCuentas.Ecodigo
                               And CUENTAS.COD_FUENTE_EMP = Empresas.EcodigoSDC
--->
<!--- Se activaría para relaciona la versión del detalle del indicador
                         left join (Select MIGMID, MIGIDETID, CECODIGO, ECODIGO,
                                           to_char(MIGIndicadorDetalle.MIGIDETFECHAINICIO,'yyyymmdd') as MIGIDETFECHAINICIO,
                                           to_char(MIGIndicadorDetalle.MIGIDETFECHAFINAL,'yyyymmdd') as MIGIDETFECHAFINAL
                                     From MIGIndicadorDetalle) Det
                                on Det.MIGMID   = F_Resumen.MIGMID
                               and Det.CECODIGO = F_Resumen.CECODIGO
                               and Det.ECODIGO  = F_Resumen.ECODIGO
                               and to_char(F_Resumen.PFecha,'yyyymmdd') >= Det.MIGIDETFECHAINICIO
                               and to_char(F_Resumen.PFecha,'yyyymmdd') <= Det.MIGIDETFECHAFINAL
                         left join (Select MIGMID, MIGIDETID, CECODIGO, ECODIGO From MIGIndicadorDetalle
                                     Where MIGIDETACTUAL = 1) Act
                                on Act.MIGMID   = F_Resumen.MIGMID
                               and Act.CECODIGO = F_Resumen.CECODIGO
                               and Act.ECODIGO  = F_Resumen.ECODIGO
--->
                        inner join <cf_dbdatabase table="F_INDICADOR" datasource="#DSNdestino#"> INDICADORES
                                on INDICADORES.COD_FUENTE               = F_Resumen.Ecodigo
                               and INDICADORES.COD_FUENTE_EMP           = Empresas.EcodigoSDC
                               and INDICADORES.ID_PERIODO               = PERIODOS.ID_PERIODO
                               and INDICADORES.ID_INDICADOR             = INDICADOR.ID_INDICADOR
                        <!---       and INDICADORES.ID_ESTRUCTURA_INF        = ESTRUCTURA_RPT.ID_ESTRUCTURA_INF
						       and COALESCE(INDICADORES.ID_PRODUCTO,-1) = COALESCE(PRODUCTOS.ID_PRODUCTO,-1)
                               and INDICADORES.ID_PRODUCTO = COALESCE(PRODUCTOS.ID_PRODUCTO,-1)
                               and INDICADORES.ID_CUENTA   = COALESCE(CUENTAS.ID_CUENTA,-1)
						       and INDICADORES.ID_INDICADOR_EXT         = COALESCE(COALESCE(Det.MIGIDETID,Act.MIGIDETID),-1)--->
					 where F_Resumen.MIGMesmetrica = 'I'
					   and F_Resumen.control >= 3
					  <cfif NOT isdefined("URL.chkTodas")>
							and F_Resumen.Ecodigo = #session.Ecodigo#
					  </cfif>
				)
	</cfquery>

<!--- Fin del Borrado de registros para la inserción --->

	<!--- Ingresa datos de Indicadores --->
	<cfquery datasource="#DSNorigen#">
	<!---
		Llenar la tabla de Hechos F_INDICADOR desde el relacional

		La llave primaria de la estructura F_INDICADOR es el campo ID_INDICADOR_DATOS.
		Para vincular la información del relacional con el dimensional se realiza por los siguientes campos:
		   F_Resumen.ECODIGO                contra el campo F_INDICADOR.COD_FUENTE
		   PERIODOS.ID_PERIODO              contra el campo F_INDICADOR.ID_PERIODO
		   INDICADOR.ID_INDICADOR           contra el campo F_INDICADOR.ID_INDICADOR
		   ESTRUCTURA_IND.ID_ESTRUCTURA_INF contra el campo F_INDICADOR.ID_ESTRUCTURA_INF
		   PRODUCTOS.ID_PRODUCTO            contra el campo F_INDICADOR.ID_PRODUCTO
		   CUENTAS.ID_CUENTA                contra el campo F_INDICADOR.ID_CUENTA
   --->
		insert into <cf_dbdatabase table="F_INDICADOR" datasource="#DSNdestino#">
			(ID_RESUMEN, COD_FUENTE_EMP, COD_FUENTE, ID_PERIODO, ID_INDICADOR, ID_ESTRUCTURA_INF, ID_MONEDA, ID_PRODUCTO, ID_CUENTA, ID_CALIFICACION, ID_INDICADOR_EXT, VALOR, META, META_ADICIONAL, TOLERANCIA_INFERIOR, TOLERANCIA_SUPERIOR, CUMPLIMIENTO, TENDENCIA, PESO, VALOR_ACUMULADO, META_ACUMULADA, CUMPLIMIENTO_ACUMULADO, VALOR_PERIODO_ANTERIOR,	META_PERIODO_ANTERIOR, CUMPLIMIENTO_PERIODO_ANTERIOR, VALOR_ANNO_ANTERIOR, META_ANNO_ANTERIOR, CUMPLIMIENTO_ANNO_ANTERIOR, VALOR_ACUMULADO_ANNO_ANTERIOR,	META_ACUMULADA_ANNO_ANTERIOR, CUMPLIMIENTO_ACUMULADO_ANO_ANT, FECHA_REGISTRO, RESULTADO_CALIFICACION, META_CALIFICACION, PESO_CALIFICACION, CUMPLIMIENTO_CALIFICACION)
		Select F_Resumen.id_resumen,
			   Empresas.EcodigoSDC as COD_FUENTE_EMP, F_Resumen.Ecodigo as COD_FUENTE, PERIODOS.ID_PERIODO,
			   ID_INDICADOR, ID_ESTRUCTURA_INF, -1 as ID_MONEDA,
			   COALESCE(
							(
							select PRODUCTOS.ID_PRODUCTO
							   from MIGProductos
							     inner join Empresas
				                    on Empresas.Ecodigo = MIGProductos.Ecodigo
								 inner join <cf_dbdatabase table="D_PRODUCTOS" datasource="#DSNdestino#"> PRODUCTOS
									on rtrim(PRODUCTOS.PRODUCTO_CODIGO) = rtrim(MIGProductos.MIGProcodigo)
								   And PRODUCTOS.COD_FUENTE             = MIGProductos.Ecodigo
								   And PRODUCTOS.COD_FUENTE_EMP         = Empresas.EcodigoSDC
							  where MIGProductos.MIGProid = F_Resumen.MIGProid
							)
						,-1) as ID_PRODUCTO,
			   COALESCE(
							(
							select CUENTAS.ID_CUENTA
							   from MIGCuentas
							     inner join Empresas
				                    on Empresas.Ecodigo = MIGCuentas.Ecodigo
								 inner join <cf_dbdatabase table="D_CUENTAS" datasource="#DSNdestino#"> CUENTAS
									on rtrim(CUENTAS.CUENTA_CODIGO) = rtrim(MIGCuentas.MIGCuecodigo)
								   And CUENTAS.CODFUENTE            = MIGCuentas.Ecodigo
								   And CUENTAS.COD_FUENTE_EMP       = Empresas.EcodigoSDC
							  where MIGCuentas.MIGCueid = F_Resumen.MIGCueid
							)
						,-1) as ID_CUENTA,
			   -1 as ID_CALIFICACION,
               COALESCE(

                    (Select INDICADOR_EXT.ID_INDICADOR_EXT
                      From <cf_dbdatabase table="D_INDICADOR_EXT" datasource="#DSNdestino#"> INDICADOR_EXT
                       Where INDICADOR_EXT.VERSION =

                             COALESCE((Select min(MIGIdetid) From MIGIndicadorDetalle Det --Se obtiene el ID menor de todos que aplican al rango
                                        Where Det.MIGMid   = F_Resumen.MIGMid
                                          and Det.CEcodigo = F_Resumen.CEcodigo
                                          and Det.Ecodigo  = F_Resumen.Ecodigo
<!---                                          and to_char(F_Resumen.Pfecha,'yyyymmdd') >= to_char(Det.MIGIdetfechainicio,'yyyymmdd')
                                          and to_char(F_Resumen.Pfecha,'yyyymmdd') <= to_char(Det.MIGIdetfechafinal,'yyyymmdd') --->
                                          and <cf_dbfunction name="to_sdate" args="F_Resumen.Pfecha"> >= <cf_dbfunction name="to_sdate" args="Det.MIGIdetfechainicio">
                                          and <cf_dbfunction name="to_sdate" args="F_Resumen.Pfecha"> <= <cf_dbfunction name="to_sdate" args="Det.MIGIdetfechafinal">
                                       ),
                                       (Select Act.MIGIdetid From MIGIndicadorDetalle Act --Se obtiene el ID actual
                                         Where Act.MIGIdetactual = 1
                                           and Act.MIGMid   = F_Resumen.MIGMid
                                           and Act.CEcodigo = F_Resumen.CEcodigo
                                           and Act.Ecodigo  = F_Resumen.Ecodigo
                                       )
                                     )
                     ),-1) as ID_INDICADOR_EXT,
			   F_Resumen.resultado as VALOR,
			   Case When MIGMetricas.Ucodigo = 'POR' Then COALESCE(MIGMetas.Meta/100,0)
                    Else COALESCE(MIGMetas.Meta,0)
			   End as Meta,

		       Case When MIGMetricas.Ucodigo = 'POR' Then COALESCE(MIGMetas.Metaadicional/100,0)
                    Else COALESCE(MIGMetas.Metaadicional,0)
		       End as Meta_ADICIONAL,
<!--- TOLERANCIA_INFERIOR --->
		   Case When MIGMetricas.MIGMtipotolerancia = 'P' And MIGMetricas.MIGMtendenciapositiva = '+'
				 And MIGMetricas.Ucodigo = 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
                     Then (MIGMetas.Meta - MIGMtoleranciainferior) / 100
				When MIGMetricas.MIGMtipotolerancia = 'P' And MIGMetricas.MIGMtendenciapositiva = '-'
				 And MIGMetricas.Ucodigo = 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
                     Then (MIGMetas.Meta + MIGMtoleranciainferior) / 100

		        When MIGMetricas.MIGMtipotolerancia = 'A' And MIGMetricas.MIGMtendenciapositiva = '+'
                 And MIGMetricas.Ucodigo != 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
                     Then MIGMetas.Meta - MIGMtoleranciainferior
		        When MIGMetricas.MIGMtipotolerancia = 'A' And MIGMetricas.MIGMtendenciapositiva = '-'
                 And MIGMetricas.Ucodigo != 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
                     Then MIGMetas.Meta + MIGMtoleranciainferior

                When MIGMetricas.MIGMtipotolerancia = 'P' And MIGMetricas.MIGMtendenciapositiva = '+'
                 And MIGMetricas.Ucodigo != 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
                     Then (MIGMetas.Meta - (MIGMetas.Meta * MIGMtoleranciainferior) ) / 100
                When MIGMetricas.MIGMtipotolerancia = 'P' And MIGMetricas.MIGMtendenciapositiva = '-'
                 And MIGMetricas.Ucodigo != 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
                     Then (MIGMetas.Meta + (MIGMetas.Meta * MIGMtoleranciainferior) ) / 100
				Else 0
		   End as TOLERANCIA_INFERIOR,
<!--- FIN TOLERANCIA_INFERIOR --->
<!--- TOLERANCIA_SUPERIOR --->
		   Case When MIGMetricas.MIGMtipotolerancia = 'P' And MIGMetricas.MIGMtendenciapositiva = '+'
				 And MIGMetricas.Ucodigo = 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
				     Then (MIGMetas.Meta + MIGMtoleranciainferior) / 100
				When MIGMetricas.MIGMtipotolerancia = 'P' And MIGMetricas.MIGMtendenciapositiva = '-'
				 And MIGMetricas.Ucodigo = 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
				     Then (MIGMetas.Meta - MIGMtoleranciainferior) / 100

		        When MIGMetricas.MIGMtipotolerancia = 'A' And MIGMetricas.MIGMtendenciapositiva = '+'
		         And MIGMetricas.Ucodigo != 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
		             Then MIGMetas.Meta + MIGMtoleranciasuperior
		        When MIGMetricas.MIGMtipotolerancia = 'A' And MIGMetricas.MIGMtendenciapositiva = '-'
		         And MIGMetricas.Ucodigo != 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
		             Then MIGMetas.Meta - MIGMtoleranciasuperior

                When MIGMetricas.MIGMtipotolerancia = 'P' And MIGMetricas.MIGMtendenciapositiva = '+'
                 And MIGMetricas.Ucodigo != 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
                     Then (MIGMetas.Meta + (MIGMetas.Meta * MIGMtoleranciainferior) ) / 100
                When MIGMetricas.MIGMtipotolerancia = 'P' And MIGMetricas.MIGMtendenciapositiva = '-'
                 And MIGMetricas.Ucodigo != 'POR' And COALESCE(MIGMtoleranciainferior,0) <> 0 And COALESCE(MIGMetas.Meta,0) <> 0
                     Then (MIGMetas.Meta - (MIGMetas.Meta * MIGMtoleranciainferior) ) / 100
				Else 0
		   End as TOLERANCIA_SUPERIOR,
<!--- FIN TOLERANCIA_SUPERIOR --->
<!--- CUMPLIMIENTO --->
			   round(COALESCE(Case When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
                                   Then F_Resumen.resultado / MIGMetas.Meta
                                   When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
                                   Then F_Resumen.resultado / (MIGMetas.Meta/100)

                                   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
                                   Then (MIGMetas.Meta + (MIGMetas.Meta - F_Resumen.resultado)) / MIGMetas.Meta
                                   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
                                   Then ((MIGMetas.Meta/100) + ((MIGMetas.Meta/100) - F_Resumen.resultado)) / (MIGMetas.Meta/100)
							  End,0), 4) as CUMPLIMIENTO,
<!--- FIN CUMPLIMIENTO --->
<!--- TENDENCIA --->
			   Case When MIGMetricas.MIGMtendenciapositiva = '+' And COALESCE(F_Resumen.resultado,0) > COALESCE(ANT.resultado,0) Then 'A'
                    When MIGMetricas.MIGMtendenciapositiva = '+' And COALESCE(F_Resumen.resultado,0) < COALESCE(ANT.resultado,0) Then 'D'
                    When MIGMetricas.MIGMtendenciapositiva = '-' And COALESCE(F_Resumen.resultado,0) > COALESCE(ANT.resultado,0) Then 'A'
                    When MIGMetricas.MIGMtendenciapositiva = '-' And COALESCE(F_Resumen.resultado,0) < COALESCE(ANT.resultado,0) Then 'D'
                    When COALESCE(F_Resumen.resultado,0) = COALESCE(ANT.resultado,0) Then 'I'
				    Else 'N'
			   End as TENDENCIA,
<!--- FIN TENDENCIA --->
				COALESCE(MIGMetas.Peso,0) as PESO,
				0 as VALOR_ACUMULADO,
			    0 as Meta_ACUMULADA,
				0 as CUMPLIMIENTO_ACUMULADO,
<!--- PERIODO_ANTERIOR --->
                COALESCE(ANT.resultado,0) as VALOR_PERIODO_ANTERIOR,
                COALESCE(Case When MIGMetricas.Ucodigo = 'POR' Then META_ANT.Meta/100 Else META_ANT.Meta End,0) as Meta_PERIODO_ANTERIOR,
	  		    round(Case When MIGMetricas.MIGMtendenciapositiva = '+' And META_ANT.Meta <> 0
			 			  <!--- Tendencia Positiva = Resultado / Meta  --->
					            Then ANT.resultado / (Case When MIGMetricas.Ucodigo = 'POR' Then META_ANT.Meta/100 Else META_ANT.Meta End)
						   When MIGMetricas.MIGMtendenciapositiva = '-' And META_ANT.Meta <> 0
						  <!--- Tendencia Negativa = (Meta + (Meta - Resultado)) / Meta  --->
						        Then ( (Case When MIGMetricas.Ucodigo = 'POR' Then META_ANT.Meta/100 Else META_ANT.Meta End)
								  	  +( (Case When MIGMetricas.Ucodigo = 'POR' Then META_ANT.Meta/100 Else META_ANT.Meta End) - ANT.resultado ) )
								     / (Case When MIGMetricas.Ucodigo = 'POR' Then META_ANT.Meta/100 Else META_ANT.Meta End)
						   Else 0 End
				     ,4)
		        as CUMPLIMIENTO_PERIODO_ANTERIOR,
<!--- FIN PERIODO_ANTERIOR --->
<!--- ANNO_ANTERIOR --->
			    COALESCE(ANNO_ANT.resultado,0) as VALOR_ANNO_ANTERIOR,
			    COALESCE(Case When MIGMetricas.Ucodigo = 'POR' Then META_ANNO_ANT.Meta/100 Else META_ANNO_ANT.Meta End,0) as META_ANNO_ANT,
	  		    round(Case When MIGMetricas.MIGMtendenciapositiva = '+' And META_ANNO_ANT.Meta <> 0
			 			  <!--- Tendencia Positiva = Resultado / Meta  --->
					            Then ANNO_ANT.resultado / (Case When MIGMetricas.Ucodigo = 'POR' Then META_ANNO_ANT.Meta/100 Else META_ANNO_ANT.Meta End)
						   When MIGMetricas.MIGMtendenciapositiva = '-' And META_ANNO_ANT.Meta <> 0
						  <!--- Tendencia Negativa = (Meta + (Meta - Resultado)) / Meta  --->
						        Then ( (Case When MIGMetricas.Ucodigo = 'POR' Then META_ANNO_ANT.Meta/100 Else META_ANNO_ANT.Meta End)
								  	   +( (Case When MIGMetricas.Ucodigo = 'POR' Then META_ANNO_ANT.Meta/100 Else META_ANNO_ANT.Meta End) - ANNO_ANT.resultado ) )
								     / (Case When MIGMetricas.Ucodigo = 'POR' Then META_ANNO_ANT.Meta/100 Else META_ANNO_ANT.Meta End)
						   Else 0 End
				     ,4)
				 as CUMPLIMIENTO_ANNO_ANTERIOR,
<!--- FIN ANNO_ANTERIOR --->
				0 as VALOR_ACUMULADO_ANNO_ANTERIOR,	0 as Meta_ACUMULADA_ANNO_ANTERIOR, 0 as CUMPLIMIENTO_ACUMULADO_ANO_ANT,
				<cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO,

<!--- RESULTADO_CALIFICACION --->
                Case --Cumplimiento > -Variable And Cumplimiento < Variable = Cumplimiento * Peso
                     When round(COALESCE(Case When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / (MIGMetas.Meta/100)

											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then (MIGMetas.Meta + (MIGMetas.Meta - F_Resumen.resultado)) / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then ((MIGMetas.Meta/100) + ((MIGMetas.Meta/100) - F_Resumen.resultado)) / (MIGMetas.Meta/100)
										  End,0), 4)  > ((Califica.Valorcalificacion / 100) * -1)
					  And round(COALESCE(Case When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / (MIGMetas.Meta/100)

											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then (MIGMetas.Meta + (MIGMetas.Meta - F_Resumen.resultado)) / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then ((MIGMetas.Meta/100) + ((MIGMetas.Meta/100) - F_Resumen.resultado)) / (MIGMetas.Meta/100)
										  End,0), 4) < (Califica.Valorcalificacion / 100)
					 Then round(COALESCE(Case When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / (MIGMetas.Meta/100)

											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then (MIGMetas.Meta + (MIGMetas.Meta - F_Resumen.resultado)) / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then ((MIGMetas.Meta/100) + ((MIGMetas.Meta/100) - F_Resumen.resultado)) / (MIGMetas.Meta/100)
										  End,0), 4) * MIGMetas.Peso
	                 --Cumplimiento < -Variable = Peso * -Variable
                     When round(COALESCE(Case When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / (MIGMetas.Meta/100)

											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then (MIGMetas.Meta + (MIGMetas.Meta - F_Resumen.resultado)) / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then ((MIGMetas.Meta/100) + ((MIGMetas.Meta/100) - F_Resumen.resultado)) / (MIGMetas.Meta/100)
										  End,0), 4)  < ((Califica.Valorcalificacion / 100) * -1)
				     Then MIGMetas.Peso * ((Califica.Valorcalificacion / 100) * -1)
	                 --Cumplimiento > Variable = Peso * Variable
                     When round(COALESCE(Case When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '+' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then F_Resumen.resultado / (MIGMetas.Meta/100)

											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo <> 'POR' And MIGMetas.Meta <> 0
											   Then (MIGMetas.Meta + (MIGMetas.Meta - F_Resumen.resultado)) / MIGMetas.Meta
											   When MIGMetricas.MIGMtendenciapositiva = '-' And MIGMetricas.Ucodigo = 'POR' And MIGMetas.Meta <> 0
											   Then ((MIGMetas.Meta/100) + ((MIGMetas.Meta/100) - F_Resumen.resultado)) / (MIGMetas.Meta/100)
										  End,0), 4)  > (Califica.Valorcalificacion / 100)
				     Then MIGMetas.Peso * (Califica.Valorcalificacion / 100)
				     Else 0
                End as RESULTADO_CALIFICACION,
<!--- FIN RESULTADO_CALIFICACION --->
				(Califica.Valorcalificacion / 100) as META_CALIFICACION,
				COALESCE(Califica.Peso,0) as PESO_CALIFICACION,
				0 as CUMPLIMIENTO_CALIFICACION <!--- RESULTADO_CALIFICACION / PESO_CALIFICACION --->
		   from F_Resumen
		  inner join Empresas
				 on Empresas.Ecodigo = F_Resumen.Ecodigo
		  inner join <cf_dbdatabase table="D_PERIODO" datasource="#DSNdestino#"> PERIODOS
				 on PERIODOS.FECHA = F_Resumen.Pfecha
		  inner join MIGMetricas
				 on MIGMetricas.MIGMid = F_Resumen.MIGMid
		  inner join <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> INDICADOR
				on INDICADOR.INDICADOR_CODIGO = MIGMetricas.MIGMcodigo
			   And INDICADOR.COD_FUENTE       = MIGMetricas.Ecodigo
			   And INDICADOR.COD_FUENTE_EMP   = Empresas.EcodigoSDC
		  inner join Departamentos
				 on Departamentos.Dcodigo = F_Resumen.Dcodigo
				And Departamentos.Ecodigo = F_Resumen.Ecodigo
		  inner join <cf_dbdatabase table="D_ESTRUCTURA_RPT" datasource="#DSNdestino#"> ESTRUCTURA_RPT
				 on rtrim(ESTRUCTURA_RPT.DEPARTAMENTO_CODIGO) = rtrim(Departamentos.Deptocodigo)
				And ESTRUCTURA_RPT.COD_FUENTE                 = Departamentos.Ecodigo
				And ESTRUCTURA_RPT.COD_FUENTE_EMP             = Empresas.EcodigoSDC

		   left join MIGMetas
 				on MIGMetas.MIGMid  = F_Resumen.MIGMid
			   And MIGMetas.Ecodigo = F_Resumen.Ecodigo
			   And MIGMetas.Periodo = F_Resumen.Periodo

		   left join (Select acum.MIGMid, acum.Periodo, acum.Dcodigo, acum.MIGProid, acum.MIGCueid, acum.Ecodigo, acum.resultado From F_Resumen acum ) ANT
				  on ANT.Ecodigo               = F_Resumen.Ecodigo
			     and ANT.MIGMid                = F_Resumen.MIGMid
				 and COALESCE(ANT.Dcodigo,-1)  = COALESCE(F_Resumen.Dcodigo,-1)
				 and COALESCE(ANT.MIGProid,-1) = COALESCE(F_Resumen.MIGProid,-1)
				 and COALESCE(ANT.MIGCueid,-1) = COALESCE(F_Resumen.MIGCueid,-1)
				 and ANT.Periodo =
								    case
									   when MIGMetricas.MIGMperiodicidad = 'D' then PERIODOS.PERIODO_D_ANT
									   when MIGMetricas.MIGMperiodicidad = 'W' then PERIODOS.PERIODO_W_ANT
									   when MIGMetricas.MIGMperiodicidad = 'M' then PERIODOS.PERIODO_M_ANT
									   when MIGMetricas.MIGMperiodicidad = 'T' then PERIODOS.PERIODO_T_ANT
									   when MIGMetricas.MIGMperiodicidad = 'S' then PERIODOS.PERIODO_S_ANT
									   when MIGMetricas.MIGMperiodicidad = 'A' then PERIODOS.PERIODO_A_ANT
									end

		   left join (Select Meta.MIGMid, Meta.Periodo, Meta.Ecodigo, Meta.Meta From MIGMetas Meta ) META_ANT
				  on META_ANT.Ecodigo = F_Resumen.Ecodigo
			     and META_ANT.MIGMid  = F_Resumen.MIGMid
				 and META_ANT.Periodo =
								    case
									   when MIGMetricas.MIGMperiodicidad = 'D' then PERIODOS.PERIODO_D_ANT
									   when MIGMetricas.MIGMperiodicidad = 'W' then PERIODOS.PERIODO_W_ANT
									   when MIGMetricas.MIGMperiodicidad = 'M' then PERIODOS.PERIODO_M_ANT
									   when MIGMetricas.MIGMperiodicidad = 'T' then PERIODOS.PERIODO_T_ANT
									   when MIGMetricas.MIGMperiodicidad = 'S' then PERIODOS.PERIODO_S_ANT
									   when MIGMetricas.MIGMperiodicidad = 'A' then PERIODOS.PERIODO_A_ANT
									end

		   left join (Select acum.MIGMid, acum.Periodo, acum.Dcodigo, acum.MIGProid, acum.MIGCueid, acum.Ecodigo, acum.resultado From F_Resumen acum ) ANNO_ANT
				  on ANNO_ANT.Ecodigo               = F_Resumen.Ecodigo
			     and ANNO_ANT.MIGMid                = F_Resumen.MIGMid
				 and COALESCE(ANNO_ANT.Dcodigo,-1)  = COALESCE(F_Resumen.Dcodigo,-1)
				 and COALESCE(ANNO_ANT.MIGProid,-1) = COALESCE(F_Resumen.MIGProid,-1)
				 and COALESCE(ANNO_ANT.MIGCueid,-1) = COALESCE(F_Resumen.MIGCueid,-1)
				 and ANNO_ANT.Periodo =
								    case
									   when MIGMetricas.MIGMperiodicidad = 'D' then PERIODOS.PERIODO_D_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'W' then PERIODOS.PERIODO_W_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'M' then PERIODOS.PERIODO_M_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'T' then PERIODOS.PERIODO_T_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'S' then PERIODOS.PERIODO_S_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'A' then PERIODOS.PERIODO_A_ANNO_ANT
									end

		   left join (Select Meta.MIGMid, Meta.Periodo, Meta.Ecodigo, Meta.Meta From MIGMetas Meta) META_ANNO_ANT
				  on META_ANNO_ANT.Ecodigo = F_Resumen.Ecodigo
			     and META_ANNO_ANT.MIGMid  = F_Resumen.MIGMid
				 and META_ANNO_ANT.Periodo =
								    case
									   when MIGMetricas.MIGMperiodicidad = 'D' then PERIODOS.PERIODO_D_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'W' then PERIODOS.PERIODO_W_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'M' then PERIODOS.PERIODO_M_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'T' then PERIODOS.PERIODO_T_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'S' then PERIODOS.PERIODO_S_ANNO_ANT
									   when MIGMetricas.MIGMperiodicidad = 'A' then PERIODOS.PERIODO_A_ANNO_ANT
									end

           left join (Select Pfechainicial, Pfechafinal, Valorcalificacion, Peso
						 From MIGParametros
						 inner join MIGParametrosdet
								 on MIGParametrosdet.MIGParid = MIGParametros.MIGParid
						  where MIGParactual = 'S'
					 ) Califica
  	              on F_Resumen.Pfecha >= Califica.Pfechainicial and F_Resumen.Pfecha <= Califica.Pfechafinal

		 where F_Resumen.MIGMesmetrica = 'I'
		   and F_Resumen.control >= 3
		<cfif NOT isdefined("URL.chkTodas")>
				and F_Resumen.Ecodigo = #session.Ecodigo#
		</cfif>
	</cfquery>


	<cfquery datasource="#DSNorigen#">
		UPDATE  F_Resumen
		   SET  control = 4
		 WHERE	F_Resumen.MIGMesmetrica = 'I'
		   and	F_Resumen.control = 3
		  <cfif NOT isdefined("URL.chkTodas")>
				and F_Resumen.Ecodigo = #session.Ecodigo#
		  </cfif>
	</cfquery>

</cfif>

