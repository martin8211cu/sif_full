<cfinclude template="../../../Utiles/sifConcat.cfm">
<cfif isdefined("Url.FMT00COD") and not isdefined("Form.FMT00COD") >
 	<cfset Form.FMT00COD = url.FMT00COD>
</cfif>


<cfparam name="url.FMT00COD" default="">

<cf_template>
<cf_templatearea name="title">
	Mantenimiento de Formatos
</cf_templatearea>
<cf_templatearea name="body">


<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tipos de Formatos de Impresión">

<table width="973" border="0" cellspacing="6">
  <tr>
    <td width="173" rowspan="2" valign="top">
	
		<cfquery datasource="sifcontrol" name="lista">
			select FMT00COD,FMT00DES
			from FMT000
		</cfquery>
		
		<cfquery datasource="sifcontrol" name="fmt011_lista">
		select FMT00COD,FMT02SQL,
		case FMT11CNT when 0 then FMT11NOM else '<strong>> '#_Cat#FMT11NOM#_Cat#'</strong>'
		end as FMT11NOM,
		case FMT11CNT when 1 then '<strong>' end #_Cat#
		case FMT10TIP when 0 then 'texto'
					  when 1 then 'número'
					  when 2 then 'fecha'
					  else '??' 
					  end #_Cat#
		case FMT11CNT when 1 then '</strong>' end
		as tipo
		  from FMT011
		 where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#" null="#Len(url.FMT00COD) IS 0#">
		 order by FMT02SQL
	</cfquery>
	<cfquery datasource="sifcontrol" name="FMT010_lista">
		select FMT00COD,FMT10LIN,FMT10PAR,
		case FMT10TIP when 0 then 'texto'
					  when 1 then 'número'
					  when 2 then 'fecha'
					  else '??' end as tipo
		from FMT010
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#" null="#Len(url.FMT00COD) IS 0#">
		order by FMT10LIN
	</cfquery>

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="FMT00COD,FMT00DES"
			etiquetas="N&uacute;mero,Nombre"
			formatos="S,S"
			align="left,left"
			ira="FMT000.cfm"
			form_method="get"
			keys="FMT00COD"
		/><br>
		<form action="" method="get" name="form_exportar" id="form_exportar" >
		<center>
		<input type="button" name="btnExportar_Sybase" onClick="funcExportar_Sybase()" value="Exportar Todos para Sybase">
		</center><center>
		<input type="button" name="btnExportar_Oracle" onClick="funcExportar_Oracle()" value="Exportar Todos para Oracle">
		</center>
		</form>
	</td>
    <td width="278" rowspan="2" valign="top">
		<cfinclude template="FMT000-form.cfm">


		
			    </td><td width="241" valign="top">
		  <cfif Len(url.FMT00COD)>
			  <cfinclude template="FMT010.cfm">
            
</cfif>
				</td><td width="243" valign="top">
		  <cfif Len(url.FMT00COD)><cfinclude template="FMT011.cfm">
		  </cfif>
	</td>
  </tr>
  <tr>
    <td valign="top">  <cfif Len(url.FMT00COD)>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	 returnvariable="pListaRet"
	 query="#FMT010_lista#"
		 desplegar="FMT10LIN,FMT10PAR,tipo"
		 etiquetas="N&ordm;,Par&aacute;metro,Tipo"
		formatos=""
		align="left, left, left "
		formName="lista3"
		form_method="get"
		ajustar="N"
		checkboxes="N"
		irA="FMT000.cfm"
		keys="FMT00COD,FMT10LIN"
		debug="N"
		MaxRows="30">
</cfinvoke> </cfif>
    </td>
    <td valign="top">		<cfif Len(url.FMT00COD)>
		  <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	 returnvariable="pListaRet"
	 query="#fmt011_lista#"
		 desplegar="FMT02SQL,FMT11NOM,tipo"
		 etiquetas="N&ordm;,Campo,Tipo"
		formatos=""
		align="left, left, left "
		formName="lista2"
		form_method="get"
		ajustar="N"
		checkboxes="N"
		irA="FMT000.cfm"
		keys="FMT00COD,FMT02SQL"
		debug="N"
		MaxRows="30">
</cfinvoke></cfif></td>
  </tr>
</table>

<script type="text/javascript">
<!--

	function funcExportar_Sybase() {
		location.href='exportar-tipo.cfm?dbms=syb';
		return false;
	}
	function funcExportar_Oracle() {
		location.href='exportar-tipo.cfm?dbms=ora';
		return false;
	}
//-->
</script>
</cf_templatearea>
<cf_web_portlet_end>
</cf_template>


