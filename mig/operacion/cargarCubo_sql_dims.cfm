<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT">
<cfset LvarOBJ.DimensionPeriodo(DSNdestino)>

<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
	Llenar la dimension D_UNIDAD_MEDIDA desde el relacional

	La llave primaria de la estructura D_UNIDAD_MEDIDA es el campo ID_UNIDAD_MEDIDA.
	Para vincular la información del relacional con el dimensional se valida en dos estructuras con diferente información, por los siguientes campos:
		Unidades.Ucodigo contra el campo UNIDAD_MEDIDA.UM_CODIGO
		Unidades.EcodigoSDC contra el campo UNIDAD_MEDIDA.COD_FUENTE_EMP
		Unidades.Ecodigo contra el campo UNIDAD_MEDIDA.COD_FUENTE

	--insert into D_UNIDAD_MEDIDA (ID_UNIDAD_MEDIDA, COD_FUENTE_EMP, COD_FUENTE, UM_CODIGO, UM_SIMBOLO, UM_NOMBRE, UM_CLS_PRIMARIA, UM_CLS_SECUNDARIA, ESTADO, FECHA_INICIAL, FECHA_FINAL, FECHA_REGISTRO)
--->
	Select COALESCE(UNIDAD_MEDIDA.ID_UNIDAD_MEDIDA,-1) as ID_UNIDAD_MEDIDA,--Este campo se valida si existe para realizar un update de los otros campos, o un insert si no existe.
		   Empresas.EcodigoSDC as COD_FUENTE_EMP, Unidades.Ecodigo as COD_FUENTE, rtrim(Unidades.Ucodigo) as UM_CODIGO, 'N/D' as UM_SIMBOLO,
                Unidades.Udescripcion as UM_NOMBRE, 'NO DEFINIDO' as UM_CLS_PRIMARIA, 'NO DEFINIDO' as UM_CLS_SECUNDARIA,
		   1 as ESTADO, null as FECHA_INICIAL, null as FECHA_FINAL,
               <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
	  From Unidades
      inner join Empresas
              on Empresas.Ecodigo = Unidades.Ecodigo
	  left join <cf_dbdatabase table="D_UNIDAD_MEDIDA" datasource="#DSNdestino#"> UNIDAD_MEDIDA
			 on rtrim(UNIDAD_MEDIDA.UM_CODIGO) = rtrim(Unidades.Ucodigo)
			And UNIDAD_MEDIDA.COD_FUENTE       = Unidades.Ecodigo
			And UNIDAD_MEDIDA.COD_FUENTE_EMP   = Empresas.EcodigoSDC
	<cfif NOT isdefined("URL.chkTodas")>
	where Unidades.Ecodigo = #session.Ecodigo#
	</cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "UNIDAD_MEDIDA", "D_UNIDAD_MEDIDA", "ID_UNIDAD_MEDIDA", "UM_CODIGO,COD_FUENTE,COD_FUENTE_EMP", DSNdestino)>

<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
	Llenar la dimension D_INDICADOR desde el relacional

	La llave primaria de la estructura D_INDICADOR es el campo ID_INDICADOR.
	Para vincular la información del relacional con el dimensional se valida en dos estructuras con diferente información, por los siguientes campos:
		MIGMEtricas.MIGMCODIGO contra el campo D_INDICADOR.INDICADOR_CODIGO
		MIGMEtricas.MIGMCODIGO contra el campo D_INDICADOR.COD_FUENTE
		Empresas.EcodigoSDC contra el campo D_INDICADOR.COD_FUENTE_EMP

	--insert into D_INDICADOR (ID_INDICADOR, COD_FUENTE, ID_UNIDAD_MEDIDA, INDICADOR_CODIGO, INDICADOR_NOMBRE, 	NOMBRE_PRESENTACION, 	INDICADOR_DESCRIPCION, INDICADOR_FACTOR_CRITICO, INDICADOR_PRESENTACION_SEQ, INDICADOR_PERIODICIDAD, INDICADOR_AGREGACION, DESCRIPCION_CALCULO, TENDENCIA_POSITIVA,	TIPO_TOLERANCIA, TOLERANCIA_INFERIOR, TOLERANCIA_SUPERIOR, INDICADOR_FILTRO, INDICADOR_PERPECTIVA, INDICADOR_NIVEL, INDICADOR_OBJETIVO, INDICADOR_PESO, 	INDICADOR_DUENNO, INDICADOR_RESPONSABLE, INDICADOR_FIJAMETA, INDICADOR_GRUPO, INDICADOR_SUBGRUPO, CODIGO_TIPO_REGISTRO, DESCRIPCION_TIPO_REGISTRO, ESTADO, FECHA_INICIO, FECHA_FIN, FECHA_REGISTRO)
--->
	Select COALESCE(ID_INDICADOR,-1) as ID_INDICADOR,--Este campo se valida si existe para realizar un update de los otros campos, o un insert si no existe.
		   Empresas.EcodigoSDC as COD_FUENTE_EMP, MIGMetricas.Ecodigo as COD_FUENTE, COALESCE(UNIDAD_MEDIDA.ID_UNIDAD_MEDIDA,-1) as ID_UNIDAD_MEDIDA,
           MIGMetricas.MIGMcodigo as INDICADOR_CODIGO, MIGMetricas.MIGMnombre as INDICADOR_NOMBRE, MIGMetricas.MIGMnpresentacion as NOMBRE_PRESENTACION,
		   MIGMetricas.MIGMdescripcion as INDICADOR_DESCRIPCION, '' as INDICADOR_FACTOR_CRITICO, MIGMetricas.MIGMsequencia as INDICADOR_PRESENTACION_SEQ,
		   case MIGMetricas.MIGMperiodicidad When 'W' Then 'SEMANAL' When 'M' Then 'MENSUAL' When 'T' Then 'TRIMESTRAL' when 'S' Then 'SEMESTRAL' When 'A' Then
		   'ANUAL' When 'D' Then 'DIARIA' else 'NO DEFINIDO' end as INDICADOR_PERIODICIDAD,
		   '' as INDICADOR_AGREGACION, MIGMetricas.MIGMcalculo as DESCRIPCION_CALCULO,
		   MIGMetricas.MIGMtendenciapositiva as TENDENCIA_POSITIVA,
		   case MIGMetricas.MIGMtipotolerancia when 'A' Then 'ABSOLUTA' when 'P' Then 'PORCENTUAL' else 'NO DEFINIDO' end as TIPO_TOLERANCIA,
		   MIGMetricas.MIGMtoleranciainferior as TOLERANCIA_INFERIOR, MIGMetricas.MIGMtoleranciasuperior as TOLERANCIA_SUPERIOR,
		   '' as INDICADOR_FILTRO, MIGPerspectiva.MIGPerdescripcion as INDICADOR_PERPECTIVA, '' as INDICADOR_NIVEL, '' as INDICADOR_OBJETIVO,
		   0 as INDICADOR_PESO, Duenno.MIGRenombre as INDICADOR_DUENNO, MIGResponsables.MIGRenombre as INDICADOR_RESPONSABLE,
		   Fijameta.MIGRenombre as INDICADOR_FIJAMETA,
		   case MIGMetricas.MIGMesmetrica when 'I' Then 'CORPORATIVO' else '' End as INDICADOR_GRUPO,
		   case MIGMetricas.MIGMesmetrica when 'I' Then 'ESTRATEGICO' else '' End as INDICADOR_SUBGRUPO,
		   case MIGMetricas.MIGMesmetrica when 'I' Then 1 When 'M' then 2 else -1 end as CODIGO_TIPO_REGISTRO,
		   case MIGMetricas.MIGMesmetrica when 'I' Then 'INDICADOR' When 'M' then 'METRICA' else 'NO DEFINIDO' end as DESCRIPCION_TIPO_REGISTRO,
		   MIGMetricas.Dactiva as ESTADO, null as FECHA_INICIO, null as FECHA_FIN,
                   <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
	 From MIGMetricas
     inner join Empresas
             on Empresas.Ecodigo = MIGMetricas.Ecodigo
	 left join Unidades
			on rtrim(Unidades.Ucodigo) = rtrim(MIGMetricas.Ucodigo)
		   And Unidades.Ecodigo        = MIGMetricas.Ecodigo
	 left join <cf_dbdatabase table="D_UNIDAD_MEDIDA" datasource="#DSNdestino#"> UNIDAD_MEDIDA
			on rtrim(UNIDAD_MEDIDA.UM_CODIGO) = rtrim(Unidades.Ucodigo)
		   And UNIDAD_MEDIDA.COD_FUENTE       = Unidades.Ecodigo
		   And UNIDAD_MEDIDA.COD_FUENTE_EMP   = Empresas.EcodigoSDC
	 left join MIGPerspectiva
			on MIGPerspectiva.MIGPerid = MIGMetricas.MIGPerid
	 left join MIGResponsables
			on MIGResponsables.MIGReid = MIGMetricas.MIGRecodigo
	 left join MIGResponsables Duenno
			on Duenno.MIGReid = MIGMetricas.MIGReidduenno
	 left join MIGResponsables Fijameta
            on Fijameta.MIGReid = MIGMetricas.MIGReidFija
	 left join <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> INDICADOR
			on INDICADOR.INDICADOR_CODIGO = MIGMetricas.MIGMcodigo
		   And INDICADOR.COD_FUENTE       = MIGMetricas.Ecodigo
           And INDICADOR.COD_FUENTE_EMP   = Empresas.EcodigoSDC
	<cfif NOT isdefined("URL.chkTodas")>
	where MIGMetricas.Ecodigo = #session.Ecodigo#
	</cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "INDICADOR", "D_INDICADOR", "ID_INDICADOR", "INDICADOR_CODIGO,COD_FUENTE,COD_FUENTE_EMP", DSNdestino)>


<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
	Llenar la dimension D_MONEDA desde el relacional

	La llave primaria de la estructura D_MONEDA es el campo ID_MONEDA.
	Para vincular la información del relacional con el dimensional se valida en dos estructuras con diferente información, por los siguientes campos:
		monedas.Mcodigo contra el campo D_MONEDA.CODIGO_ISO_ALPHA
		Empresas.EcodigoSDC contra el campo D_MONEDA.COD_FUENTE
		monedas.Ecodigo contra el campo D_MONEDA.COD_FUENTE_EMP
	--insert into D_MONEDA (ID_MONEDA, COD_FUENTE, CODIGO_ISO, CODIGO_ISO_ALPHA, NOMBRE_CORTO, NOMBRE_LARGO, NOMBRE_PAIS, ISO_CODIGO_NUMERICO, SIMBOLO_MONEDA, 	ESTADO, FECHA_INICIO, FECHA_FIN, FECHA_REGISTRO)

--->
	Select COALESCE(MONEDA.ID_MONEDA,-1) as ID_MONEDA,--Este campo se valida si existe para realizar un update de los otros campos, o un insert si no existe.
		   Empresas.EcodigoSDC as COD_FUENTE_EMP, MIGMonedas.Ecodigo as COD_FUENTE, MIGMonedas.Miso4217 as CODIGO_ISO, MIGMonedas.Mcodigo as CODIGO_ISO_ALPHA,
           MIGMonedas.Mnombre as NOMBRE_CORTO, MIGMonedas.Mnombre as NOMBRE_LARGO, 'NO DEFINIDO' as NOMBRE_PAIS, 'N/D' as ISO_CODIGO_NUMERICO,
           MIGMonedas.Msimbolo as SIMBOLO_MONEDA, 1 as ESTADO, null as FECHA_INICIO, null as FECHA_FIN,
           <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
	 From MIGMonedas
     inner join Empresas
             on Empresas.Ecodigo = MIGMonedas.Ecodigo
	 left join <cf_dbdatabase table="D_MONEDA" datasource="#DSNdestino#"> MONEDA
			on MONEDA.CODIGO_ISO_ALPHA = MIGMonedas.Mcodigo
		   And MONEDA.COD_FUENTE       = MIGMonedas.Ecodigo
		   And MONEDA.COD_FUENTE_EMP   = Empresas.EcodigoSDC
	<cfif NOT isdefined("URL.chkTodas")>
	where MIGMonedas.Ecodigo = #session.Ecodigo#
	</cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "MONEDA", "D_MONEDA", "ID_MONEDA", "CODIGO_ISO_ALPHA,COD_FUENTE,COD_FUENTE_EMP", DSNdestino)>


<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
	Llenar la información desde las tablas relacionales hacia la dimensión D_PRODUCTOS

	La llave primaria de la estructura D_PRODUCTOS es el campo ID_PRODUCTOS.
	Para vincular la información del relacional con el dimensional se valida en dos estructuras con diferente información, por los siguientes campos:
		MIGProductos.MIGProcodigo contra el campo D_PRODUCTOS.PRODUCTO_CODIGO
		Empresas.EcodigoSDC contra el campo D_PRODUCTOS.COD_FUENTE_EMP
		MIGProductos.Ecodigo contra el campo D_PRODUCTOS.COD_FUENTE

	--insert into D_PRODUCTOS (ID_PRODUCTO, COD_FUENTE_EMP, COD_FUENTE, ESPRODUCTO, ID_UNIDAD_MEDIDA, SEGMENTO, SEGMENTO2, SEGMENTO3, LINEA_NEGOCIO, LINEA_NEGOCIO2, LINEA_NEGOCIO3, LINEA_NEGOCIO4, LINEA_NEGOCIO5, PRODUCTO_NOMBRE, PRODUCTO_CODIGO, ESNUEVO, PRODUCTO_PLANTA, PRODUCTO_ACTIVIDAD, PRODUCTO_SUBACTIVIDAD, ESTADO, FECHA_INICIO, FECHA_FIN, FECHA_REGISTRO)
--->
	Select COALESCE(PRODUCTOS.ID_PRODUCTO,-1) as ID_PRODUCTO, --Este campo se valida si existe para realizar un update de los otros campos, o un insert si no existe.
		   Empresas.EcodigoSDC as COD_FUENTE_EMP, MIGProductos.Ecodigo as COD_FUENTE, MIGProductos.MIGProesproducto as ESPRODUCTO,
		   COALESCE(UNIDAD_MEDIDA.ID_UNIDAD_MEDIDA,-1) as ID_UNIDAD_MEDIDA,
		   MIGProSegmentos.MIGProSegdescripcion as SEGMENTO, Segmento2.MIGProSegdescripcion as SEGMENTO2, Segmento3.MIGProSegdescripcion as SEGMENTO3,
		   MIGProLineas.MIGProLindescripcion as LINEA_NEGOCIO,Linea2.MIGProLindescripcion as LINEA_NEGOCIO2, Linea3.MIGProLindescripcion as LINEA_NEGOCIO3,
		   Linea4.MIGProLindescripcion as LINEA_NEGOCIO4, MIGProductos.MIGProlinea5 as LINEA_NEGOCIO5, MIGProductos.MIGPronombre as PRODUCTO_NOMBRE,
		   MIGProductos.MIGProcodigo as PRODUCTO_CODIGO, case MIGProductos.MIGProesnuevo when 1 then 'S' when 0 then 'N' end as ESNUEVO,
		   MIGProductos.MIGProplanta as PRODUCTO_PLANTA, MIGProductos.MIGProactividad as PRODUCTO_ACTIVIDAD, MIGProductos.MIGProsubactividad as PRODUCTO_SUBACTIVIDAD,
		   MIGProductos.Dactiva as ESTADO, null as FECHA_INICIO, null as FECHA_FIN,
                   <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
	 From MIGProductos
     inner join Empresas
             on Empresas.Ecodigo = MIGProductos.Ecodigo
	 inner join MIGProLineas
			 on MIGProLineas.MIGProLinid = MIGProductos.MIGProLinid
	 left join MIGProLineas Linea2
			on Linea2.MIGProLinid = MIGProductos.MIGProLinid2
	 left join MIGProLineas Linea3
			on Linea3.MIGProLinid = MIGProductos.MIGProLinid3
	 left join MIGProLineas Linea4
			on Linea4.MIGProLinid = MIGProductos.MIGProLinid4
	 left join MIGProSegmentos
			on MIGProSegmentos.MIGProSegid = MIGProductos.MIGProSegid
	 left join MIGProSegmentos Segmento2
			on Segmento2.MIGProSegid = MIGProductos.MIGProSegid2
	 left join MIGProSegmentos Segmento3
			on Segmento3.MIGProSegid = MIGProductos.MIGProSegid3
	 left join <cf_dbdatabase table="D_UNIDAD_MEDIDA" datasource="#DSNdestino#"> UNIDAD_MEDIDA -- Dimensión de Unidad de Medidas
			on rtrim(UNIDAD_MEDIDA.UM_CODIGO) = rtrim(MIGProductos.id_unidad_medida)
		   And UNIDAD_MEDIDA.COD_FUENTE       = MIGProductos.Ecodigo
		   And UNIDAD_MEDIDA.COD_FUENTE_EMP   = Empresas.EcodigoSDC
	 left join <cf_dbdatabase table="D_PRODUCTOS" datasource="#DSNdestino#"> PRODUCTOS -- Dimensión de Productos
			on rtrim(PRODUCTOS.PRODUCTO_CODIGO) = rtrim(MIGProductos.MIGProcodigo)
		   And PRODUCTOS.COD_FUENTE             = MIGProductos.Ecodigo
		   And PRODUCTOS.COD_FUENTE_EMP         = Empresas.EcodigoSDC
	<cfif NOT isdefined("URL.chkTodas")>
	where MIGProductos.Ecodigo = #session.Ecodigo#
	</cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "PRODUCTOS", "D_PRODUCTOS", "ID_PRODUCTO", "PRODUCTO_CODIGO,COD_FUENTE,COD_FUENTE_EMP", DSNdestino)>

<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
	Llenar la dimension D_CUENTAS desde el relacional

	La llave primaria de la estructura D_CUENTAS es el campo ID_CUENTAS.
	Para vincular la información del relacional con el dimensional se realiza por los siguientes campos:
		MIGCUENTAS.MIGCuecodigo contra el campo D_CUENTAS.CUENTA_CODIGO
		MIGCUENTAS.EcodigoSDC contra el campo D_CUENTAS.COD_FUENTE_EMP
        MIGCUENTAS.Ecodigo contra el campo D_CUENTAS.CODFUENTE

	--Insert into D_CUENTAS (ID_CUENTA, COD_FUENTE_EMP, CODFUENTE, CUENTA_CODIGO, CUENTA_DESCRIPCION, CUENTA_TIPO, CUENTA_SUBTIPO, ESTADO, FECHA_INICIO, FECHA_FIN, FECHA_REGISTRO)
--->
	Select COALESCE(CUENTAS.ID_CUENTA,-1) as ID_CUENTA, -- Este campo se valida si existe para realizar un update de los otros campos, o un insert si no existe.
		   Empresas.EcodigoSDC as COD_FUENTE_EMP, MIGCuentas.Ecodigo as CODFUENTE, MIGCuentas.MIGCuecodigo as CUENTA_CODIGO,
           MIGCuentas.MIGCuedescripcion as CUENTA_DESCRIPCION,
		   case MIGCuentas.MIGCuetipo when 'I' then 'INGRESOS' when 'G' then 'GASTOS' when 'C' then 'COSTOS' when 'A' then 'ACTIVOS'
                                      when 'P' then 'PASIVOS' when 'T' then 'CAPITAL' Else 'NO APLICA' end as CUENTA_TIPO,
           MIGCuentas.MIGCuesubtipo as CUENTA_SUBTIPO,
		   MIGCuentas.Dactiva as ESTADO, null as FECHA_INICIO, null as FECHA_FIN,
           <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
	 From MIGCuentas
     inner join Empresas
             on Empresas.Ecodigo = MIGCuentas.Ecodigo
	 left join <cf_dbdatabase table="D_CUENTAS" datasource="#DSNdestino#"> CUENTAS
			on CUENTAS.CUENTA_CODIGO  = MIGCuentas.MIGCuecodigo
		   And CUENTAS.CODFUENTE      = MIGCuentas.Ecodigo
		   And CUENTAS.COD_FUENTE_EMP = Empresas.EcodigoSDC
	<cfif NOT isdefined("URL.chkTodas")>
	where MIGCuentas.Ecodigo = #session.Ecodigo#
	</cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "CUENTAS", "D_CUENTAS", "ID_CUENTA", "CUENTA_CODIGO,CODFUENTE,COD_FUENTE_EMP", DSNdestino)>


<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
    Llenar la dimension D_ESTRUCTURA_RPT desde el relacional

	La llave primaria de la estructura D_ESTRUCTURA_RPT es el campo ID_ESTRUCTURA_INF.
	Para vincular la información del relacional con el dimensional se realiza por los siguientes campos:
		Departamentos.DEPTOCODIGO contra el campo D_ESTRUCTURA_RPT.DEPARTAMENTO_CODIGO
		Departamentos.EcodigoSDC contra el campo D_ESTRUCTURA_RPT.COD_FUENTE_EMP
		Departamentos.Ecodigo contra el campo D_ESTRUCTURA_RPT.COD_FUENTE

    --insert into D_ESTRUCTURA_RPT (ID_ESTRUCTURA_INF, COD_FUENTE_EMP, COD_FUENTE, CORPORACION, TIPO_ORGANIZACION, TIPO_ORGANIZACION_DESCRIPCION, COMPANIA_CODIGO, COMPANIA_NOMBRE, 	OFICINA_CODIGO, OFICINA_NOMBRE, VICEPRESIDENCA_CODIGO, VICEPRESIDENCA_NOMBRE, DIRECCION_CODIGO, DIRECCION_NOMBRE, SUBDIRECCION_CODIGO, SUBDIRECCION_NOMBRE,	GERENCIA_CODIGO, GERENCIA_NOMBRE, DEPARTAMENTO_CODIGO, DEPARTAMENTO_NOMBRE, CENTROCOSTO_CODIGO, CENTROCOSTO_NOMBRE, PAIS, REGION, ESTADO_GEOGRAFICO, DISTRITO,   	AREA, NOMBRE_PERSONA_RESPONSABLE, TIPO_PERSONA, GRADO_PERSONA, PESONA_SUMINISTRA_INFORMACION, FIJA_META, PESO_DE_LA_ESTRUCTURA, ESTADO, FECHA_INICIO, FECHA_FIN,	FECHA_REGISTRO)
--->
	Select COALESCE(ESTRUCTURA_RPT.ID_ESTRUCTURA_INF,-1) as ID_ESTRUCTURA_INF,--Este campo se valida si existe para realizar un update de los otros campos, o un insert si no existe.
		   Empresas.EcodigoSDC as COD_FUENTE_EMP, Departamentos.Ecodigo as COD_FUENTE,
           (Select CuentaEmpresarial.CEnombre
             From CuentaEmpresarial
             left join Empresa
                    on CuentaEmpresarial.Ecorporativa = Empresa.Ecodigo
              Where Empresa.CEcodigo = Empresas.cliente_empresarial
           ) as CORPORACION,
		   'N/D' as TIPO_ORGANIZACION, 'NO DEFINIDO' as TIPO_ORGANIZACION_DESCRIPCION,
		   Departamentos.Ecodigo as COMPANIA_CODIGO, Empresas.Edescripcion as COMPANIA_NOMBRE, 'N/D' as OFICINA_CODIGO, 'NO DEFINIDO' as OFICINA_NOMBRE,
		   'N/D' as VICEPRESIDENCA_CODIGO, 'NO DEFINIDO' as VICEPRESIDENCA_NOMBRE, MIGDireccion.MIGDcodigo as DIRECCION_CODIGO,
		   MIGDireccion.MIGDnombre as DIRECCION_NOMBRE, MIGSDireccion.MIGSDcodigo as SUBDIRECCION_CODIGO, MIGSDireccion.MIGSDdescripcion as SUBDIRECCION_NOMBRE,
		   MIGGerencia.MIGGcodigo as GERENCIA_CODIGO, MIGGerencia.MIGGdescripcion as GERENCIA_NOMBRE, rtrim(Departamentos.Deptocodigo) as DEPARTAMENTO_CODIGO,
		   Departamentos.Ddescripcion as DEPARTAMENTO_NOMBRE, 'N/D' as CENTROCOSTO_CODIGO, 'NO DEFINIDO' as CENTROCOSTO_NOMBRE, 'NO DEFINIDO' as PAIS,
		   'NO DEFINIDO' as REGION, 'NO DEFINIDO' as ESTADO_GEOGRAFICO, 'NO DEFINIDO' as DISTRITO, 'NO DEFINIDO' as AREA,
		   PERSONA_RESPONSABLE.MIGRenombre as NOMBRE_PERSONA_RESPONSABLE, 'NO DEFINIDO' as TIPO_PERSONA,
		   'N/D' as GRADO_PERSONA, PESONA_SUMINISTRA_INFORMACION.MIGRenombre as PESONA_SUMINISTRA_INFORMACION,
		   PESONA_FIJA_META.MIGRenombre as FIJA_META, null as PESO_DE_LA_ESTRUCTURA,
		   MIGDireccion.Dactiva as ESTADO, null as FECHA_INICIO, null as FECHA_FIN,
                   <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
	 From Departamentos
	 inner join Empresas
             on Empresas.Ecodigo = Departamentos.Ecodigo
	 left join MIGGerencia
			on MIGGerencia.MIGGid = Departamentos.MIGGid
	 left join MIGSDireccion
			on MIGSDireccion.MIGSDid = MIGGerencia.MIGSDid
	 left join MIGDireccion
			on MIGDireccion.MIGDid = MIGSDireccion.MIGDid
	 left join (Select MIGResponsablesDepto.Ecodigo, MIGResponsablesDepto.Dcodigo, MIGResponsables.MIGRenombre, Min(MIGResponsablesDepto.MIGReid) as MIGREID
				 from MIGResponsablesDepto
				 inner join MIGResponsables
				         on MIGResponsables.MIGReid = MIGResponsablesDepto.MIGReid
                 Where MIGResponsablesDepto.MIGRDeptoNivel = 'P'
                Group by MIGResponsablesDepto.Ecodigo, MIGResponsablesDepto.Dcodigo, MIGResponsables.MIGRenombre
                ) PERSONA_RESPONSABLE
			 on PERSONA_RESPONSABLE.Dcodigo = Departamentos.Dcodigo
			And PERSONA_RESPONSABLE.Ecodigo = Departamentos.Ecodigo
	 left join (Select MIGResponsablesDepto.Ecodigo, MIGResponsablesDepto.Dcodigo, MIGResponsables.MIGRenombre, Min(MIGResponsablesDepto.MIGReid) as MIGREID
				 from MIGResponsablesDepto
				 inner join MIGResponsables
				         on MIGResponsables.MIGReid = MIGResponsablesDepto.MIGReid
				   Where MIGResponsablesDepto.MIGResptipo = 'S'
                Group by MIGResponsablesDepto.Ecodigo, MIGResponsablesDepto.Dcodigo, MIGResponsables.MIGRenombre
			   ) PESONA_SUMINISTRA_INFORMACION
			 on PESONA_SUMINISTRA_INFORMACION.Dcodigo = Departamentos.Dcodigo
			And PESONA_SUMINISTRA_INFORMACION.Ecodigo = Departamentos.Ecodigo
	 left join (Select MIGResponsablesDepto.Ecodigo, MIGResponsablesDepto.Dcodigo, MIGResponsables.MIGRenombre, Min(MIGResponsablesDepto.MIGReid) as MIGREID
				 from MIGResponsablesDepto
				 inner join MIGResponsables
				         on MIGResponsables.MIGReid = MIGResponsablesDepto.MIGReid
				   Where MIGResponsablesDepto.MIGResptipo = 'M'
                Group by MIGResponsablesDepto.Ecodigo, MIGResponsablesDepto.Dcodigo, MIGResponsables.MIGRenombre
				) PESONA_FIJA_META
			 on PESONA_FIJA_META.Dcodigo = Departamentos.Dcodigo
			And PESONA_FIJA_META.Ecodigo = Departamentos.Ecodigo
	  left join <cf_dbdatabase table="D_ESTRUCTURA_RPT" datasource="#DSNdestino#"> ESTRUCTURA_RPT
			 on rtrim(ESTRUCTURA_RPT.DEPARTAMENTO_CODIGO) = rtrim(Departamentos.Deptocodigo)
			And ESTRUCTURA_RPT.COD_FUENTE                 = Departamentos.Ecodigo
			And ESTRUCTURA_RPT.COD_FUENTE_EMP             = Empresas.EcodigoSDC
	<cfif NOT isdefined("URL.chkTodas")>
	where Departamentos.Ecodigo = #session.Ecodigo#
	</cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "ESTRUCTURA_RPT", "D_ESTRUCTURA_RPT", "ID_ESTRUCTURA_INF", "DEPARTAMENTO_CODIGO,COD_FUENTE,COD_FUENTE_EMP", DSNdestino)>

<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
	Llenar la dimension D_GEOGRAFIA desde el relacional

	La llave primaria de la estructura D_GEOGRAFIA es el campo ID_GEOGRAFIA.
	Para vincular la información del relacional con el dimensional se valida en dos estructuras con diferente información, por los siguientes campos:
		MIGDISTRITOADICIONAL.MIGDITCODIGO contra el campo D_GEOGRAFIA.CODIGO_DISTRITO_TELEFONICO
		MIGDISTRITOADICIONAL.Ecodigo contra el campo D_GEOGRAFIA.COD_FUENTE
		MIGDISTRITOADICIONAL.ID_ATR_DIM1 contra el campo D_GEOGRAFIA.ID_CENTRAL

	Si el registro no existe en esta relación, se realiza la búsqueda en esta estructura:
		MIGDISTRITO.MIGDICODIGO contra el campo D_GEOGRAFIA.CODIGO_GEOGRAFIA
		MIGDISTRITO.Ecodigo contra el campo D_GEOGRAFIA.COD_FUENTE

	-- insert into D_GEOGRAFIA (ID_GEOGRAFIA, ID_CENTRAL, COD_FUENTE_EMP, COD_FUENTE, CODIGO_GEOGRAFIA, CODIGO_PAIS, DESCRIPCION_PAIS, CODIGO_ST_PROV, DESCRIPCION_ST_PROV,	CODIGO_AREA_CANTON, DESCRIPCION_AREA_CANTON, CODIGO_DISTRITO, DESCRIPCION_DISTRITO, CODIGO_CIUDAD, DESCRIPCION_CIUDAD, REGION, ZONA, SUB_CONTINENTE_ABR,	CONTINENTE_ABR, CODIGO_DISTRITO_TELEFONICO, DESCRIPCION_DISTRITOTELEFONICO, ESTADO, FECHA_INICIO, FECHA_FIN, FECHA_REGISTRO)
--->
	Select COALESCE(GEOGRAFIA.ID_GEOGRAFIA,-1) as ID_GEOGRAFIA, COALESCE(ATRIBUTO.ID_CENTRAL,-1) as ID_CENTRAL,
           Empresas.EcodigoSDC as COD_FUENTE_EMP, Empresas.Ecodigo as COD_FUENTE, MIGDistrito.MIGDicodigo as CODIGO_GEOGRAFIA,
           MIGPais.MIGPacodigo as CODIGO_PAIS, MIGPais.MIGPadescripcion as DESCRIPCION_PAIS, MIGRegion.MIGRcodigo as CODIGO_ST_PROV,
           MIGRegion.MIGRdescripcion as DESCRIPCION_ST_PROV, MIGArea.MIGArcodigo as CODIGO_AREA_CANTON, MIGArea.MIGArdescripcion as DESCRIPCION_AREA_CANTON,
           rtrim(MIGDistrito.MIGDicodigo) as CODIGO_DISTRITO, MIGDistrito.MIGDidescripcion as DESCRIPCION_DISTRITO, 'N/D' as CODIGO_CIUDAD,
           'NO DEFINIDO' as DESCRIPCION_CIUDAD, 'NO DEFINIDO' as REGION, 'NO DEFINIDO' as ZONA, 'CAM' as SUB_CONTINENTE_ABR, 'AME' as CONTINENTE_ABR,
           rtrim(COALESCE(MIGDistritoAdicional.MIGDitcodigo,'N/D')) as CODIGO_DISTRITO_TELEFONICO,
		   COALESCE(MIGDistritoAdicional.MIGDitdescripcion,'NO DEFINIDO') as DESCRIPCION_DISTRITOTELEFONICO, MIGDistrito.Dactiva as ESTADO,
		   null as FECHA_INICIO, null as FECHA_FIN,
           <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
	 from MIGDistrito
     inner join Empresas
             on Empresas.Ecodigo = MIGDistrito.Ecodigo
	 left join MIGDistritoAdicional
			on MIGDistritoAdicional.MIGDiid = MIGDistrito.MIGDiid
	 inner join MIGArea
			 on MIGArea.MIGArid = MIGDistrito.MIGArid
	 inner join MIGRegion
			 on MIGRegion.MIGRid = MIGArea.MIGRid
	 inner join MIGPais
			 on MIGPais.MIGPaid = MIGRegion.MIGPaid
	 left join <cf_dbdatabase table="D_CENTRAL" datasource="#DSNdestino#"> ATRIBUTO
            on ATRIBUTO.CODIGO_CENTRAL = MIGDistritoAdicional.id_atr_dim1
           And ATRIBUTO.CODFUENTE      = MIGDistritoAdicional.Ecodigo
	 left join <cf_dbdatabase table="D_GEOGRAFIA" datasource="#DSNdestino#"> GEOGRAFIA
            on rtrim(GEOGRAFIA.CODIGO_DISTRITO)     = rtrim(MIGDistrito.MIGDicodigo)
           And GEOGRAFIA.COD_FUENTE                 = MIGDistrito.Ecodigo
           And GEOGRAFIA.COD_FUENTE_EMP             = Empresas.EcodigoSDC
		   And GEOGRAFIA.ID_CENTRAL                 = COALESCE(ATRIBUTO.ID_CENTRAL,-1)
	       And GEOGRAFIA.CODIGO_DISTRITO_TELEFONICO = COALESCE(MIGDistritoAdicional.MIGDitcodigo,'N/D')
	<cfif NOT isdefined("URL.chkTodas")>
	where MIGDistrito.Ecodigo = #session.Ecodigo#
	</cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "GEOGRAFIA", "D_GEOGRAFIA", "ID_GEOGRAFIA", "COD_FUENTE_EMP ,COD_FUENTE,CODIGO_DISTRITO,ID_CENTRAL,CODIGO_DISTRITO_TELEFONICO", DSNdestino)>

<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
	Llenar la dimension D_INDICADOR_EXT desde el relacional. Esta información es el detalle del indicador, asociado por el ID del Indicador.

	La llave primaria de la estructura D_INDICADOR_EXT es el campo ID_INDICADOR_EXT.
	Para vincular la información del relacional con el dimensional se valida en dos estructuras con diferente información, por los siguientes campos:
		MIGIndicadorDetalle.MIGIdetid contra el campo D_INDICADOR_EXT.VERSION
		MIGIndicadorDetalle.Ecodigo contra el campo D_INDICADOR_EXT.COD_FUENTE
		Empresas.EcodigoSDC contra el campo D_INDICADOR_EXT.COD_FUENTE_EMP

	--Insert into D_INDICADOR_EXT (ID_INDICADOR_EXT,ID_INDICADOR,COD_FUENTE_EMP,CODFUENTE,VERSION,CATEGORIA,SUBCATEGORIA,REGLAMENTACION,PESO,RIGUROSIDAD,FACTOR,META,ESTADO,FACTOR_CRITICO,ESTRATEGIA,OBJETIVO_ESTRATEGICO,FECHA_INICIO,FECHA_FIN,FECHA_REGISTRO)
      -- Descripciones del Detalle de Indicadores
--->
    Select --Este campo se valida si existe para realizar un update de los otros campos, o un insert si no existe.
           COALESCE((Select INDICADOR_EXT.ID_INDICADOR_EXT
                      From <cf_dbdatabase table="D_INDICADOR_EXT" datasource="#DSNdestino#"> INDICADOR_EXT
                       Where INDICADOR_EXT.VERSION        = MIGIndicadorDetalle.MIGIdetid
		                 /*And INDICADOR_EXT.CODFUENTE      = MIGIndicadorDetalle.Ecodigo
                         And INDICADOR_EXT.COD_FUENTE_EMP = MIGIndicadorDetalle.CEcodigo*/),-1) as ID_INDICADOR_EXT,
           COALESCE((Select INDICADOR.ID_INDICADOR
                      From <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> INDICADOR
                       Where INDICADOR.INDICADOR_CODIGO = MIGMetricas.MIGMcodigo
		                 And INDICADOR.COD_FUENTE       = MIGMetricas.Ecodigo
                         And INDICADOR.COD_FUENTE_EMP   = Empresas.EcodigoSDC),-1) as ID_INDICADOR,
           Empresas.EcodigoSDC as COD_FUENTE_EMP, MIGIndicadorDetalle.Ecodigo as CODFUENTE, MIGIdetid as VERSION,
           'DETALLE INDICADOR' as CATEGORIA, 'N/A' as SUBCATEGORIA, 'N/A' as REGLAMENTACION, null as PESO, null as RIGUROSIDAD, null as FACTOR, null as META,
           MIGIdetactual as ESTADO,
           COALESCE((Select MIGFCritico.MIGFCcodigo From MIGFCritico
                      Where MIGFCritico.MIGFCid = MIGIndicadorDetalle.MIGFCid), 'N/D') as CODIGO_FACTOR_CRITICO,
           COALESCE((Select MIGFCritico.MIGFCdescripcion From MIGFCritico
                      Where MIGFCritico.MIGFCid = MIGIndicadorDetalle.MIGFCid), 'NO DEFINIDO') as FACTOR_CRITICO,
           COALESCE((Select MIGEstrategia.MIGEstcodigo From MIGEstrategia
                      Where MIGEstrategia.MIGEstid = MIGIndicadorDetalle.MIGEstid), 'N/D') as CODIGO_ESTRATEGIA,
           COALESCE((Select MIGEstrategia.MIGEstdescripcion From MIGEstrategia
                      Where MIGEstrategia.MIGEstid = MIGIndicadorDetalle.MIGEstid), 'NO DEFINIDO') as ESTRATEGIA,
           COALESCE((Select MIGOEstrategico.MIGOEcodigo From MIGOEstrategico
                      Where MIGOEstrategico.MIGOEid = MIGIndicadorDetalle.MIGOEid), 'N/D') as CODIGO_OBJETIVO_ESTRATEGICO,
           COALESCE((Select MIGOEstrategico.MIGOEdescripcion From MIGOEstrategico
                      Where MIGOEstrategico.MIGOEid = MIGIndicadorDetalle.MIGOEid), 'NO DEFINIDO') as OBJETIVO_ESTRATEGICO,
           MIGIndicadorDetalle.MIGIdetfechainicio as FECHA_INICIO, MIGIndicadorDetalle.MIGIdetfechafinal as FECHA_FIN,
           <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
    From MIGIndicadorDetalle
    inner join Empresas
            on Empresas.Ecodigo = MIGIndicadorDetalle.Ecodigo
    inner join MIGMetricas
            on MIGMetricas.MIGMid = MIGIndicadorDetalle.MIGMid

  <cfif NOT isdefined("URL.chkTodas")>
     Where MIGIndicadorDetalle.Ecodigo = #session.Ecodigo#
  </cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "INDICADOR_DETALLES", "D_INDICADOR_EXT", "ID_INDICADOR_EXT", "COD_FUENTE_EMP,CODFUENTE,VERSION", DSNdestino)>


<!--- Borra la información en la Asociación que se modificó en el modelo relacional --->
<cfquery datasource="#DSNorigen#">
  TRUNCATE TABLE <cf_dbdatabase table="FA_INDICADOR_RELACION" datasource="#DSNdestino#">

<!---
 <cfquery name="rsSQL" datasource="#DSNorigen#">
   DELETE FROM <cf_dbdatabase table="FA_INDICADOR_RELACION" datasource="#DSNdestino#">
     WHERE FA_INDICADOR_RELACION.ID_INDICADOR_RELACION not in
           (Select COALESCE((Select INDICADOR_METRICA_RELACION.ID_INDICADOR_RELACION
							  From <cf_dbdatabase table="FA_INDICADOR_RELACION" datasource="#DSNdestino#"> INDICADOR_METRICA_RELACION
							   Where INDICADOR_METRICA_RELACION.ID_INDICADOR             = INDICADOR.ID_INDICADOR
								 And INDICADOR_METRICA_RELACION.ID_INDICADOR_RELACIONADO = METRICA.ID_INDICADOR
								 And INDICADOR_METRICA_RELACION.COD_FUENTE               = MIGFiltrosmetricas.Ecodigo
								 And INDICADOR_METRICA_RELACION.COD_FUENTE_EMP           = MIGFiltrosmetricas.CEcodigo
                    ),-1) as ID_INDICADOR_RELACION
			  From MIGFiltrosmetricas
			 inner join (select distinct CECODIGO, ECODIGO, MIGMIDINDICADOR, MIGMID From MIGFiltrosindicadores) Filtrosind
					 on Filtrosind.MIGMidindicador = MIGFiltrosmetricas.MIGMID
			 inner join Empresas
					 on Empresas.Ecodigo = MIGFiltrosmetricas.Ecodigo
			 inner join MIGMetricas Ind
					 on Ind.MIGMID = MIGFiltrosmetricas.MIGMID
			 inner join <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> INDICADOR
					 on INDICADOR.INDICADOR_CODIGO = Ind.MIGMCODIGO
					And INDICADOR.COD_FUENTE       = Ind.ECODIGO
					And INDICADOR.COD_FUENTE_EMP   = Empresas.EcodigoSDC
			 inner join Departamentos
					 on Departamentos.dcodigo = MIGFiltrosmetricas.MIGMdetalleid
					And Departamentos.ecodigo = MIGFiltrosmetricas.ecodigo
			 inner join <cf_dbdatabase table="D_ESTRUCTURA_RPT" datasource="#DSNdestino#"> ESTRUCTURA_RPT
					 on rtrim(ESTRUCTURA_RPT.DEPARTAMENTO_CODIGO) = rtrim(Departamentos.DEPTOCODIGO)
					And ESTRUCTURA_RPT.COD_FUENTE                 = Departamentos.Ecodigo
			 inner join MIGMetricas Met
					 on Met.MIGMID = Filtrosind.MIGMID
			 inner join <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> METRICA
					 on METRICA.INDICADOR_CODIGO = Met.MIGMCODIGO
					And METRICA.COD_FUENTE       = Met.ECODIGO
					And METRICA.COD_FUENTE_EMP   = Empresas.EcodigoSDC
             Where
        		  <cfif NOT isdefined("URL.chkTodas")>
						MIGFiltrosmetricas.Ecodigo = #session.Ecodigo#
        		  </cfif>
			)
--->
</cfquery>


<cfquery name="rsSQL" datasource="#DSNorigen#">
<!---
	Llenar la tabla de Asociación FA_INDICADOR_RELACION desde el relacional

	La llave primaria de la estructura FA_INDICADOR_RELACION es el campo ID_INDICADOR_RELACION.
	Para vincular la información del relacional con el dimensional se realiza por los siguientes campos:
		MIGIndicadorestructura.ECODIGO contra el campo FA_INDICADOR_RELACION.CODIGO_FUENTE
		INDICADOR.ID_IND_SISTEMA contra el campo FA_INDICADOR_RELACION.ID_IND_SISTEMA

	    --insert into FA_INDICADOR_RELACION (ID_INDICADOR_RELACION, ID_IND_SISTEMA, COD_FUENTE_EMP, COD_FUENTE, ID_INDICADOR, ID_INDICADOR_RELACIONADO, ID_ESTRUCTURA_INF, ROL_NOMBRE, ROL_DESCRIPCION, FECHA_REGISTRO)
--->
		Select COALESCE((Select INDICADOR_METRICA_RELACION.ID_INDICADOR_RELACION
						  From <cf_dbdatabase table="FA_INDICADOR_RELACION" datasource="#DSNdestino#"> INDICADOR_METRICA_RELACION
						   Where INDICADOR_METRICA_RELACION.ID_INDICADOR             = INDICADOR.ID_INDICADOR
							 And INDICADOR_METRICA_RELACION.ID_INDICADOR_RELACIONADO = METRICA.ID_INDICADOR
							 And INDICADOR_METRICA_RELACION.COD_FUENTE               = MIGFiltrosmetricas.Ecodigo
							 And INDICADOR_METRICA_RELACION.COD_FUENTE_EMP           = MIGFiltrosmetricas.CEcodigo
						),-1) as ID_INDICADOR_RELACION,
		   <cf_dbfunction name="to_char" args="COALESCE(INDICADOR.ID_INDICADOR,-1)"> #_CAT# <cf_dbfunction name="to_char" args="COALESCE(METRICA.ID_INDICADOR,-1)"> as ID_IND_SISTEMA,
		   Empresas.EcodigoSDC as COD_FUENTE_EMP, MIGFiltrosmetricas.Ecodigo as COD_FUENTE,
		   COALESCE(INDICADOR.ID_INDICADOR,-1) as ID_INDICADOR, COALESCE(METRICA.ID_INDICADOR,-1) as ID_INDICADOR_RELACIONADO,
		   COALESCE(ESTRUCTURA_RPT.ID_ESTRUCTURA_INF,-1) as ID_ESTRUCTURA_INF,
		   'METRICAS POR INDICADOR' as ROL_NOMBRE,
		   'INDICADOR ' #_CAT# Ind.MIGMcodigo #_CAT# ' CON METRICA ' #_CAT# Met.MIGMcodigo #_CAT# ', DEPTO ' #_CAT#  Departamentos.Deptocodigo as ROL_DESCRIPCION,
		   <cf_dbfunction name="today" datasource="#DSNorigen#"> as FECHA_REGISTRO
		From MIGFiltrosmetricas
		inner join (select distinct CEcodigo, Ecodigo, MIGMidindicador, MIGMid From MIGFiltrosindicadores) Filtrosind
			 on Filtrosind.MIGMidindicador = MIGFiltrosmetricas.MIGMid
		inner join Empresas
			 on Empresas.Ecodigo = MIGFiltrosmetricas.Ecodigo
		inner join MIGMetricas Ind
			 on Ind.MIGMid = MIGFiltrosmetricas.MIGMid
		inner join <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> INDICADOR
			 on INDICADOR.INDICADOR_CODIGO = Ind.MIGMcodigo
			And INDICADOR.COD_FUENTE       = Ind.Ecodigo
			And INDICADOR.COD_FUENTE_EMP   = Empresas.EcodigoSDC
		inner join Departamentos
			 on Departamentos.Dcodigo = MIGFiltrosmetricas.MIGMdetalleid
			And Departamentos.Ecodigo = MIGFiltrosmetricas.Ecodigo
		inner join <cf_dbdatabase table="D_ESTRUCTURA_RPT" datasource="#DSNdestino#"> ESTRUCTURA_RPT
			 on rtrim(ESTRUCTURA_RPT.DEPARTAMENTO_CODIGO) = rtrim(Departamentos.Deptocodigo)
			And ESTRUCTURA_RPT.COD_FUENTE                 = Departamentos.Ecodigo
		inner join MIGMetricas Met
			 on Met.MIGMid = Filtrosind.MIGMid
		inner join <cf_dbdatabase table="D_INDICADOR" datasource="#DSNdestino#"> METRICA
			 on METRICA.INDICADOR_CODIGO = Met.MIGMcodigo
			And METRICA.COD_FUENTE       = Met.Ecodigo
			And METRICA.COD_FUENTE_EMP   = Empresas.EcodigoSDC
  <cfif NOT isdefined("URL.chkTodas")>
     Where MIGFiltrosmetricas.Ecodigo = #session.Ecodigo#
  </cfif>
</cfquery>
<cfset LvarOBJ.toCube(rsSQL, "Dimensiones", "INDICADOR_METRICA_RELACION", "FA_INDICADOR_RELACION", "ID_INDICADOR_RELACION", "COD_FUENTE_EMP,ID_IND_SISTEMA", DSNdestino)>
