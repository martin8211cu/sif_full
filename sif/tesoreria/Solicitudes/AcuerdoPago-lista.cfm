<cf_dbdatabase table="Usuario" datasource="asp" returnvariable="TableUsuario">
<form name="formAcuerdoPago" action="AcuerdoPago-sql.cfm" method="post">
	 <cfinvoke component="sif.Componentes.pListas"
		method			="pLista"
		returnvariable	="Lvar_Lista"
		tabla			="TESacuerdoPago a left outer join #TableUsuario# b on b.Usucodigo = a.BMUsucodigo"
		columnas		="TESAPid,TESAPnumero,TASAPfecha,b.Usulogin "
		desplegar		="TESAPnumero, TASAPfecha, Usulogin"
		etiquetas		="Numero Acuerdo, Fecha, Usuario #MSGTipo#"
		formatos		="S,D,S"
		filtro			="Ecodigo = #session.Ecodigo# and TESAPestado = #Tipo#"
		incluyeform		="false"
		align			="left,left,left"
		keys			="TESAPid"
		maxrows			="25"
		showlink		="true"
		filtrar_automatico="true"
		mostrar_filtro	="true"
		formname		="formAcuerdoPago"
		ira				="#IrA#"
		showemptylistmsg="true"
		ajustar			="N"
		debug			="N"
		botones			="#BotonesLista#"/>
	<input type="hidden" name="IrA" id="IrA" value="<cfoutput>#IrA#</cfoutput>"/>			
</form>
