<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="to_char" args="ER.ERDid" 		returnvariable="lvarToCharERDid">
<form name="form1" id="form1" method="post" action="ReportDinamic-sql.cfm" >
    <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
		columnas=" ER.ERDid, ER.ERDdesc, ER.ERDmodulo, ER.ERDcodigo"
		tabla="EReportDinamic ER"
		filtro="ER.Ecodigo=#session.Ecodigo# order by ER.ERDcodigo"
		desplegar="ERDcodigo,ERDdesc"
		etiquetas="Código, Descripción "
		formName="form1"
		formatos="S,S,U"
		align="left,left"
		ira="ReportDinamic-sql.cfm"
		mostrar_filtro="true"
		filtrar_automatico="true"
		keys="ERDid"	
		MaxRows="15"
		checkboxes="N"
		PageIndex="10"
	/>
    </form>
<div align="center">
	<form name="formNuevo" id="formNuevo" method="post" action="ReportDinamic-sql.cfm" >
		<input name="NUEVO" id="NUEVO" value="Nuevo Reporte" class="btnNuevo" type="submit" />
   </form>
</div>
