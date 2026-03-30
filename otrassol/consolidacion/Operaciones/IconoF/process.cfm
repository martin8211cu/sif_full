<cfsetting showdebugoutput="yes" requesttimeout="1000">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Proceso de importaci&oacute;n de Icono F</title>
</head>

<body>

<!--- Esta pantalla no muestra salida
	a menos que haya excepciones/errores.
	El reporte de avance considera:
	20% - carga del archivo
	80% - insert en base de datos
--->

<cfset session.load_status = "">
<cfset session.load_percent = 0>
<cfset session.load_started = Now()>
<cfset session._time = StructNew()>
<cfset session.load_finished = false>
<cfset session.load_abort   = false>

<cffunction name="status" output="no">
	<cfargument name="text"    required="yes">
	<cfargument name="percent" required="no" default="0">
	<cfset session.load_status  = text>
    <cfset session.load_percent = percent>
    <cfif session.load_abort>
    	<cfabort>
    </cfif>
</cffunction>

<cffunction name="timer" output="no"><!---
	<cfargument name="section" required="yes">
	<cfif not IsDefined("session._time")>
		<cfset session._time = StructNew()>
    </cfif>

	<cfset currentMillis = CreateObject("java", "java.lang.System").currentTimeMillis()>
    
    <cfif IsDefined("session._starttime") and IsDefined("session._time.section")>
    	<cfif not IsDefined("session._time.#session._time.section#")>
        	<cfset session._time[session._time.section] = 0>
        </cfif>
    	<cfset session._time[session._time.section] = session._time[session._time.section] + (currentMillis - session._starttime)>
    </cfif>
    <cfset session._starttime = currentMillis>
    <cfset session._time.section = Arguments.section>--->
</cffunction>


<cffunction name="ref2rc" output="no" returntype="struct" hint="Convierte una referencia (eg: B7) en RC (eg: 7,2)">
	<cfargument name="ref" required="yes">
    <cfscript>
    var ret = StructNew();
	var i = 0;
	ret.row = 0;
    ret.col = 0;
    for (i=1; i LE Len(Arguments.ref); i++) {
    	nextchar = Mid(Arguments.ref, i, 1);
        if (nextchar GE "0" and nextchar LE "9") {
           	ret.row = ret.row * 10 + nextchar;
		} else {
			ret.col = (ret.col * 26) + Asc(nextchar) - 64;
		}
	}
    return ret;
	</cfscript>
</cffunction>

<cfset status( "Abriendo archivo excel..." ) >
<!--- cargar en $TEMP --->
<cffile action="upload" fileField="form.archivo" destination="#GetTempDirectory()#" nameConflict="Overwrite"> 
<!--- Abrir JAR y cargar en memoria en variables.excel --->
<cfinvoke component="jar" method="load" 
	jarfile="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" 
    returnvariable="excel" />
<!--- borrar de $TEMP --->
<cftry>
<cffile action="delete" file="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >
<cfcatch type="any"></cfcatch>
</cftry>

<!--- Leer y parsear XML del archivo de strings --->
<cfset status( "Cargando strings..." ) >
<cfset strings = excel["xl/sharedStrings.xml"]>

<cfset status( "Analizando strings..." ) >
<cfset strings = XMLParse(strings)>
<cfset strings = XMLSearch(strings, '/:sst/:si')>

<!--- Leer y parsear XML del archivo de sheet1 --->
<cfset status( "Cargando sheet1..." ) >
<cfset sheet1  = excel["xl/worksheets/sheet1.xml"]>

<cfset status( "Analizando sheet1..." ) >
<cfset sheet1  = XMLParse(sheet1)>

<cfset status( "Extrayendo cells..." ) >
<cfset cells = XMLSearch(sheet1, '/:worksheet/:sheetData/:row/:c')>

<cfflush>

<!--- Generar array bidimensional con las celdas del excel --->
<cfset cellCount = ArrayLen(cells)>
<cfset cellArray = ArrayNew(2)>

<cfscript>
// convierte cells + strings = cellArray 2-dimensiones (fila/columna)
for (i=1; i<=cellCount; i++) {
	timer("BLOCK1");
    cell = cells[i];
    cellValue = "";
    if (IsDefined("cell.v.XmlText")) {
        cellValue = cell.v.XmlText;
	}
    
	timer("BLOCK2");
    if (IsDefined("cell.XmlAttributes.t")) {
		timer("BLOCK2a");
        cellValue = strings[1+cellValue].t.XmlText;
		timer("BLOCK2b");
	}
	
	timer("BLOCK3");	
    cellReference = cell.XmlAttributes.r;
	
	
	timer("BLOCK4");
    refRC = ref2rc(cellReference);
	
	timer("BLOCK5");
    cellArray [ refRC.row ] [ refRC.col ] = cellValue;
	
	timer("BLOCK6");
	status( "Examino celda #i# de #cellCount#", i * 20.0 / cellCount);
}
</cfscript>

<!--- convierte cellArray en inserts de base de datos a tabla de IconoF  --->

<cfquery datasource="#session.dsn#">
	delete Cons_IconoF
    where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
      and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">
</cfquery>

<cfset rowCount = ArrayLen(cellArray)>
<cfset vars = ListToArray(
						  "Sociedad,Soc_Asoc,Ejercicio_periodo,Cuenta_consolidacion," & "Referencia_I,Referencia_II,Descripcion,Monto," &
						  "Moneda,Monto_Debe,Monto_Haber,Moneda_Contabilizacion")>
<cfloop from="2" to="#rowCount#" index="rowindex"><cfsilent>
    
    <!---
	Columnas en el excel:
		Sociedad	Soc_Asoc	Ejercicio_periodo	Cuenta_consolidacion	
		Referencia_I	Referencia_II	Descripcion	Monto	
		Moneda	Monto_Debe	Monto_Haber	Moneda_Contabilizacion
	--->

	<cfscript>
	status( "Cargando fila #rowindex-1# de #rowCount-1#", 20.0 + (rowindex-1) * 80.0 / (rowCount-1));
	row = cellArray[rowindex];
    for (varindex=1; varindex <= 12; varindex++) {
        if (ArrayIsDefined(row,varindex)) {
        	variables[vars[varindex]] = row[varindex];
		} else {
        	variables[vars[varindex]] = "";
		}
    }
	</cfscript>
    
    <cfquery datasource="#session.dsn#">
    insert into Cons_IconoF (
		Periodo, Mes, Ecodigo, Linea,
        Sociedad, Soc_Asoc, Ejercicio_periodo, Cuenta_consolidacion,
        Referencia_I, Referencia_II, Descripcion, Monto,
        Moneda, Monto_Debe, Monto_Haber, Moneda_Contabilizacion)
	values (
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">,
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">,
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#rowindex#">,
        
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Sociedad#" null="#Len(Trim(Sociedad)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Soc_Asoc#" null="#Len(Trim(Soc_Asoc)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ejercicio_periodo#" null="#Len(Trim(Ejercicio_periodo)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cuenta_consolidacion#" null="#Len(Trim(Cuenta_consolidacion)) is 0#">,
        
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Referencia_I#" null="#Len(Trim(Referencia_I)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Referencia_II#" null="#Len(Trim(Referencia_II)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Descripcion#" null="#Len(Trim(Descripcion)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_money" value="#Monto#" null="#Len(Trim(Monto)) is 0#">,
        
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Moneda#" null="#Len(Trim(Moneda)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_money" value="#Monto_Debe#" null="#Len(Trim(Monto_Debe)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_money" value="#Monto_Haber#" null="#Len(Trim(Monto_Haber)) is 0#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Moneda_Contabilizacion#" null="#Len(Trim(Moneda_Contabilizacion)) is 0#">
    )

    </cfquery>
</cfsilent></cfloop>

<cfset session.load_finished = true>
<cfset status( "Archivo cargado exitosamente", 100.0)>

</body>
</html>
