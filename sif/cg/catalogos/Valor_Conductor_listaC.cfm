
<cf_templateheader title="Conductor"> 
<cf_web_portlet_start border="true" titulo="Conductor" skin="#Session.Preferences.Skin#">

<!---Esto es para la navegacion de la lista por si llegara a necesitarla--->
<cfif isdefined("url.Speriodo") >
	<cfset form.Speriodo = url.Speriodo>
</cfif>

<cfif isdefined("url.Smes") >
	<cfset form.Smes = url.Smes>
</cfif>

<!---Copiar valores--->
	<script language="javascript1.1" type="text/javascript">
		var popUpWinSN=0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
			}
			popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			window.onfocus = closePopUp;
		}
		
		
		function Marcar(c) {
			if (c.checked) {
				for (counter = 0; counter < document.form1.chk.length; counter++)
				{
					if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
						{  document.form1.chk[counter].checked = true;}
				}
				if ((counter==0)  && (!document.form1.chk.disabled)) {
					document.form1.chk.checked = true;
				}
			}
			else {
				for (var counter = 0; counter < document.form1.chk.length; counter++)
				{
					if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
						{  document.form1.chk[counter].checked = false;}
				};
				if ((counter==0) && (!document.form1.chk.disabled)) {
					document.form1.chk.checked = false;
				}
			};
		}
		
		
		function doConlis(){		
			var LvarCHK = '';
			var LvarCHKs = '';
			for (var i=0; i < document.form1.chk.length; i++) {
				if (document.form1.chk[i].checked) { 
					LvarCHK = document.form1.chk[i].value;
					LvarCHKs += ',' + LvarCHK.split('|')[2];
				} 
			}
			LvarCHKs = LvarCHKs.substr(1);
	
			<cfoutput>
				popUpWindow("/cfmx/sif/cg/catalogos/CGCCopiarValores.cfm?smes=#form.smes#&speriodo=#form.speriodo#&params="+LvarCHKs,300,300,350,200);<!---350*200--->
			</cfoutput>
		}
		
		function closePopUp(){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
				popUpWinSN=null;
			}
		}
		
		function funcfiltro(){
		<cfoutput>
			document.form1.action='Valor_Conductor_listaC.cfm';
			document.form1.submit();
		</cfoutput>
		}
	</script>
	
<cfoutput>
<form name="form1" method="post" action="Valor_Conductor_sql.cfm">


<!---Calculo del period anterior--->
<cfif form.smes gt 1 >
	<cfset mesant= form.smes -1>
	<cfset perant= form.speriodo>
</cfif>

<cfif form.smes eq 1>
	<cfset mesant= 12>
	<cfset perant= form.speriodo -1>
</cfif>
<input type="hidden" name="smes" value="#form.smes#" />
<input type="hidden" name="speriodo" value="#form.speriodo#" />

<table width="100%">
	<tr>	
		<td width="100%" ><strong>Peri&oacute;do:&nbsp;</strong>#form.Speriodo#</td>
	</tr>	
	<tr>	
		<td width="100%" ><strong>Mes:&nbsp;</strong>#form.Smes#</td>
		<td width="100%" colspan="4" ><input type="submit" name="reg" value="Regresar" /></td>	
	</tr>	
	
	<tr bgcolor="CCCCCC" ><td colspan="7">&nbsp;</td>
		<tr>
			<td colspan="2"><input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);">Seleccionar Todas
			</td>
		</tr>
	
</table>


<!---En caso de que tipo sea =1--->
	<cfquery name="rsQueryLista" datasource="#session.dsn#">
		select 
				CGCid, 
				CGCcodigo, 
				CGCdescripcion,
				case when CGCmodo = 1 then 'Catálogo' 
						when CGCmodo= 2 then 'Clasificación'
				end as tipo,
				case 
						when CGCmodo = 1 then
								(( 
									   select count(1) 
									   from PCDCatalogo cat
									   where cat.PCEcatid =  con.CGCidc
								))
						when CGCmodo = 2 then
								(( 
									   select count(1) 
									   from PCClasificacionD  cat
									   where cat.PCCEclaid =  con.CGCidc
								))
				end as CantidadTeorica,
				((
						select count(1)
						from CGParamConductores v
						where v.Ecodigo = con.Ecodigo
						   and v.CGCperiodo = #form.speriodo#
						   and v.CGCmes = #form.smes#
						   and v.CGCid = con.CGCid
				)) as Capturados,
				coalesce (( ((
						select sum(CGCvalor)
						from CGParamConductores v
						where v.Ecodigo = con.Ecodigo
						   and v.CGCperiodo = #form.speriodo#
						   and v.CGCmes = #form.smes#
						   and v.CGCid = con.CGCid
				))),0) as SumaControl,
				((
						select count(1)
						from CGParamConductores v
						where v.Ecodigo = con.Ecodigo
						   and v.CGCperiodo = #perant#
						   and v.CGCmes = #mesant#
						   and v.CGCid = con.CGCid
				)) as CapturadosAnt,
				coalesce ((((
						select sum(CGCvalor)
						from CGParamConductores v
						where v.Ecodigo = con.Ecodigo
						   and v.CGCperiodo = #perant#
						   and v.CGCmes = #mesant#
						   and v.CGCid = con.CGCid
				))),0) as SumaControlAnt
		from CGConductores con
		where con.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>	
	<table width="100%">	
	<tr>	
		<td width="100%">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#rsQueryLista#"
				columnas="CGCid,CGCcodigo,CGCdescripcion,tipo,CantidadTeorica,Capturados,SumaControl,CapturadosAnt,SumaControlAnt"
				desplegar="CGCcodigo,CGCdescripcion,tipo,CantidadTeorica,Capturados,SumaControl,CapturadosAnt,SumaControlAnt"
				etiquetas="Conductor,Nombre,Tipo,Total,Capturados,Suma Control,Capturados </br> Mes Anterior,Suma Control </br> Mes Anterior"
				formatos="S,S,S,S,S,M,S,M"
				align="left,left,left,left,left,right,right,right"
				ira="Valor_Conductor_form.cfm?speriodo=#form.Speriodo#&smes=#form.Smes#"
				showlink="true"
				showEmptyListMsg="yes"
				keys="CGCcodigo,CGCdescripcion,CGCid"	
				MaxRows="30"
				navegacion="&speriodo=#form.Speriodo#&smes=#form.Smes#"	
				checkboxes="S"
				incluyeForm="false"
				formName="form1"							
				/>	
		</td>
	</tr>	
	<tr>
		<td align="center">
			<input type="button" name="copiar" id="copiar" value="Copiar Valores desde Origen" onclick="doConlis()"/>			
		</td>
	</tr>
</table>
</form>
</cfoutput>
  <cf_web_portlet_end>
<cf_templatefooter>
