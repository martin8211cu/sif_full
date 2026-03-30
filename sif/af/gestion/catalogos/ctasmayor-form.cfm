<cfif isdefined("url.Cmayor") and not isdefined("form.Cmayor")>
	<cfset form.Cmayor = url.Cmayor>
</cfif>

<!--- Consultas --->
<cfset columnas = "
	A.Cmayor,
	A.Cmascara,
	B.Cdescripcion, 
	B.Ctipo,
	case 
		when B.Ctipo = 'A' then 'Tipo: Activo'
		when B.Ctipo = 'P' then 'Tipo: Pasivo'
		when B.Ctipo = 'C' then 'Tipo: Capital'
		when B.Ctipo = 'I' then 'Tipo: Ingreso'
		when B.Ctipo = 'G' then 'Tipo: Gasto'
		when B.Ctipo = 'O' then 'Tipo: Orden'
	else ''
	end as Tipo,
	'<img border=''0'' src=''/cfmx/sif/imagenes/Borrar01_S.gif''>' as Eliminar">
		
<cfset tabla = "
	GACMayor A
		inner join CtasMayor B on
			A.Ecodigo = B.Ecodigo and
			A.Cmayor = B.Cmayor">

<cfset filtro = "
	A.Ecodigo=#session.Ecodigo# order by B.Ctipo, A.Cmayor">

<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet"
		tabla="#tabla#"
		columnas="#columnas#"
		desplegar="Cmayor,Cmascara,Cdescripcion,Eliminar"
		etiquetas="Cuenta Mayor, Máscara, Descripción,	"
		formatos="S,S,S,U"
		filtro="#filtro#"
		align="left,left,left,left"
		ajustar="N,N,N,N"
		checkboxes="N"
		keys="Cmayor,Cmascara"
		MaxRows="18"
		filtrar_automatico="true"
		mostrar_filtro="true"
		filtrar_por="A.Cmayor,A.Cmascara, B.Cdescripcion,B.Ctipo,&nbsp;"
		showLink="false"
		incluyeForm="true"
		formName="lista"
		irA="Ctasmayor-sql.cfm"
		funcion="window.parent.eliminar"
		fparams="Cmayor,Cmascara"
		showEmptyListMsg="true"
		cortes="Tipo" />

<form method="post" name="form2" id="form2" action="ctasmayor-sql.cfm" >		
	<input type="hidden" name="mayor" value="" />
	<input type="hidden" name="formato" value="" />
	<input type="hidden" name="modo" value="" />	
</form>		

<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function eliminar(llave, mascara){
		if (confirm('¿Desea eliminar la cuenta: ' + llave + '-' + mascara + ' ?')){
			document.form2.mayor.value = llave;
			document.form2.formato.value = mascara;
			document.form2.modo.value = 'BAJA';
			document.form2.submit();
		}
	}	
</script>
</cfoutput>