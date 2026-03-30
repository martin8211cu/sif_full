


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Linea" Default= "L&iacute;nea" XmlFile="contratoL.xml" returnvariable="LB_Linea"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default= "C&oacute;digo" XmlFile="contratoL.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default= "Descripci&oacute;n" XmlFile="contratoL.xml" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Total" Default= "Total" XmlFile="contratoL.xml" returnvariable="LB_Total"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ref" Default= "Ref." XmlFile="contratoL.xml" returnvariable="LB_Ref"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo" Default= "Tipo" XmlFile="contratoL.xml" returnvariable="LB_Tipo"/>




<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<style type="text/css">
<!--
.style7 {color: #FF0000; font-weight: bold; }
-->
</style>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
  <!---Es x plan de compras?---->

   <cfquery name="rsMontoMax" datasource="#session.dsn#">
    select CTCmontomax, CTCMcodigo  from CTCompradores
	where Ecodigo = #session.Ecodigo#
	and Usucodigo = #session.Usucodigo#
   </cfquery>
   <cfif rsContrato.Mcodigo neq  rsMontoMax.CTCMcodigo>   
       <cfquery datasource="#session.dsn#" name="rsHtc">
			select coalesce(TCventa,0) as TCventa 
			from Htipocambio 
			where Mcodigo = #rsMontoMax.CTCMcodigo# 
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between Hfecha and Hfechah 
	   </cfquery>
	   <cfif rsHtc.recordcount eq 0>
	     <cfset LvarTC =  1>
	   <cfelse>
	    <cfset  LvarTC =  rsHtc.TCventa>
	   </cfif>
	</cfif> 

	<tr>
		<td class="subTitulo"><font size="2">Lista de Detalles</font></td>
        
	</tr>
</table>
<cf_dbfunction name="to_char" args="a.CTDCont" returnvariable="CTDCont">
<cf_dbfunction name="to_char" args="a.CTContid" returnvariable="Contrato">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return EditarLinea('+#PreserveSingleQuotes(CTDCont)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/iedit.gif''></a>&nbsp;'" returnvariable="edit" delimiters="+">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return EliminarLinea('+#PreserveSingleQuotes(CTDCont)#+','+#PreserveSingleQuotes(Contrato)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/idelete.gif''></a>&nbsp;'" returnvariable="eliminar" delimiters="+">



<!---Lista de Items--->
<cfquery name="rsListaItems" datasource="#session.dsn#">
	select 	a.CTDCont as Linea,
	        a.CTContid,
			<!---e.Ucodigo,--->			
			#PreserveSingleQuotes(edit)# as editar,
			#PreserveSingleQuotes(eliminar)# as eliminar,
			a.CTDCconsecutivo, 
			case a.CMtipo when 'A' then 'Artículo'  when 'C' then 'Artículo' when 'S' then 'Servicio' when 'F' then 'Activo' when 'P' then 'Obras' end as CMTipodesc,
			a.CTDCdescripcion, 
            a.CTDCmontoTotalOri,
			a.CTDCmontoTotal as  CTDCmontoTotal, 
			case CMtipo when 'A' then e.Acodigo when 'C' then '-' when 'F' then '-' when 'S' then f.Ccodigo when 'P' then 'P' end as Codigo, 
            a.CPDDid,
			case when CPDEid is not null then 'Suf'end as ref
	from CTDetContrato a
		left outer join Articulos e
			on a.Aid = e.Aid

		left outer join Conceptos f
			on a.Cid = f.Cid


	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
		and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
	Order by CTDCconsecutivo
</cfquery>



<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
        	<input type="hidden" name="CPDDid"  value="<cfif (modoDet EQ "CAMBIO")>#rsListaItems.CPDDid#</cfif>">
			<cfset navegacion = "">
			<cfif isdefined("form.CTContid") and len(trim(form.CTContid)) >
				<cfset navegacion = navegacion & "&CTContid=#form.CTContid#">
			</cfif>


			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				<cfinvokeargument name="query" value="#rsListaItems#">
				<cfinvokeargument name="desplegar" value="CTDCconsecutivo,ref,CMTipodesc,Codigo,CTDCdescripcion,CTDCmontoTotalOri">
				<cfinvokeargument name="etiquetas" value="#LB_Linea#,#LB_Ref#,#LB_Tipo#,#LB_Codigo#,#LB_Descripcion#,#LB_Total#">
				<cfinvokeargument name="formatos" value="V,V,V,V,V,M">
				<cfinvokeargument name="align" value="left,center,left,left,left,right">
				<cfinvokeargument name="ajustar" value="N">
				<cfinvokeargument name="irA" value="registroContratos.cfm">
				<cfinvokeargument name="incluyeForm" value="true">
				<cfinvokeargument name="formName" value="form1">
				<cfinvokeargument name="funcion" value="ProcesarLinea">
				<cfinvokeargument name="fparams" value="Linea">
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
            
		</td>		
	</tr>
</table>
<hr width="99%" align="center">

<!---Línea de Totales--->
<table width="99%"  border="0" cellspacing="0" cellpadding="0">
<cfoutput>

			
			
	  </td>
  </tr>
	<script language='javascript' type='text/JavaScript' >
	<!--//
		function ProcesarLinea(Linea){
			document.form1.CTDCont.value=Linea;
			document.form1.action="registroContratos.cfm";						
			document.form1.submit();			
		}
			function EditarLinea(Linea){
				alert("aqui");
			var PARAM  = "ordenCompraLEdit.cfm?linea="+linea;
			open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=600,height=300');			
		}	
		function EliminarLinea(Linea,Contrato){
		if ( confirm('¿Desea borrar esta línea del documento?') ) {
       		window.location = "ordenCompraLEdit-SQL.cfm?linea="+linea+"&Contrato="+Contrato+"&modo=BAJA";
		 }	
		}	
	//-->
	</script>
</cfoutput>
</table>