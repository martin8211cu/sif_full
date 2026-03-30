<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Lista de Alumnos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<!--- <link href="../../css/portlets.css" rel="stylesheet" type="text/css"> --->
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>

<!--- Consulta de Alumnos --->
	<cfquery name="conlis" datasource="#Session.Edu.DSN#">
		select c.Ecodigo,
			a.persona,
			(a.Papellido1 + ' ' + a.Papellido2 + ',' + a.Pnombre) as Nombre,
			b.Pnombre,
			convert(varchar,a.Pnacimiento,103) as Pnacimiento, 
			a.Pid,
			f.Gdescripcion as Grado,
			case when c.Aretirado=0 then 'Activo' when c.Aretirado=1 then 'Retirado' when c.Aretirado=2 then 'Graduado' end as estado
		from PersonaEducativo a, Pais b, Alumnos c, Estudiante d, Grado f, Promocion e, Nivel g 
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and e.PRactivo = 1 
			and a.Ppais=b.Ppais 
			and a.persona=c.persona 
			and a.CEcodigo=c.CEcodigo 
			and c.persona=d.persona 
			and c.Ecodigo=d.Ecodigo 
			and c.PRcodigo=e.PRcodigo 
			and e.Gcodigo=f.Gcodigo 
			and e.Ncodigo=f.Ncodigo 
			and f.Ncodigo=g.Ncodigo
			and c.CEcontrato is null
		<cfif isdefined("form.btnFiltraAlum") and isdefined("form.nombreAlumno") AND #form.nombreAlumno# NEQ "" >
			and upper((a.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like upper('%#Form.nombreAlumno#%')		
		</cfif> 
		<cfif isdefined("form.filtro_Pid") and isdefined("form.filtro_Pid") AND #form.filtro_Pid# NEQ "" >
			and upper(Pid) like upper('%#Form.filtro_Pid#%')
		</cfif> 
		<cfif isdefined("Form.FNcodigo") AND Form.FNcodigo NEQ "-1" >
			 and e.Ncodigo = #Form.FNcodigo#
		</cfif>
		<cfif isdefined("Form.FGcodigo") AND Form.FGcodigo NEQ "-1">							
			 and e.Gcodigo = #Form.FGcodigo#																																																																							
		</cfif>				
		order by g.Norden,f.Gorden,e.Gcodigo,c.Nombre
	</cfquery>
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
		select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		order by Norden
	</cfquery>	
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
		select convert(varchar, b.Ncodigo)
			   + '|' + convert(varchar, b.Gcodigo) as Codigo, 
			   b.Gdescripcion
		from Nivel a, Grado b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.Ncodigo = b.Ncodigo 
		order by a.Norden, b.Gorden
	</cfquery>
	
	<script language="JavaScript" type="text/javascript">
		var gradostext = new Array();
		var grados = new Array();
		var niveles = new Array();
	
		// Esta función únicamente debe ejecutarlo una vez
		function obtenerGrados(f) {
			for(i=0; i<f.FGcodigo.length; i++) {
				var s = f.FGcodigo.options[i].value.split("|");
				// Códigos de los detalles
				niveles[i]= s[0];
				grados[i] = s[1];
				gradostext[i] = f.FGcodigo.options[i].text;
			}
		}
		
		function cargarGrados(csource, ctarget, vdefault, t){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var k = csource.value;
			var j = 0;
			if (t) {
				var nuevaOpcion = new Option("Todos","-1");
				ctarget.options[j]=nuevaOpcion;
				j++;
			}
			if (k != "-1") {
				for (var i=0; i<grados.length; i++) {
					if (niveles[i] == k) {
						nuevaOpcion = new Option(gradostext[i],grados[i]);
						ctarget.options[j]=nuevaOpcion;

						if (vdefault != null && grados[i] == vdefault) {
							ctarget.selectedIndex = j;
						}
						j++;
					}
				}
			} else {
				for (var i=0; i<grados.length; i++) {
					nuevaOpcion = new Option(gradostext[i],grados[i]);
					ctarget.options[i+1]=nuevaOpcion;
					if (vdefault != null && grados[i] == vdefault) {
						ctarget.selectedIndex = i+1;
					}					
				}
			}
			if (!t) {
				var j = ctarget.length;
				nuevaOpcion = new Option("-------------------","");
				ctarget.options[j++]=nuevaOpcion;
				nuevaOpcion = new Option("Crear Nuevo ...","0");
				ctarget.options[j]=nuevaOpcion;
			}
		}
		
		function noMatr(obj){
			if(obj.checked)
				obj.form.FAretirado.checked = false;
		}
	</script>	
	

	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfparam name="PageNum_conlis" default="1">
	<cfset MaxRows_conlis=16>
	<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
	<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
	<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
	<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
	<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
	</cfif>

	<script language="JavaScript1.2" type="text/javascript">
		function Asignar(valor,Nomb) {
			window.opener.document.<cfoutput>#url.form#.#url.Ecodigo#</cfoutput>.value=valor;
			window.opener.document.<cfoutput>#url.form#.#url.NombreAl#</cfoutput>.value=Nomb;	
			var DivVerDiaEstud 	= window.opener.document.getElementById("verDiaEstud");
			
			DivVerDiaEstud.style.display = "none";

 			window.close();
		}
	</script>

<body>
	<form action="" method="post" name="conlis">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="areaFiltro">
		  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="subTitulo">Nombre del Alumno</td>
            <td class="subTitulo">Identificaci&oacute;n</td>
            <td width="12%" rowspan="2" align="center" valign="middle"><input name="btnFiltraAlum" type="submit" id="btnFiltraAlum" value="Filtrar" /></td>
          </tr>
          <tr> 
            <td width="60%"><input name="nombreAlumno" type="text" id="nombreAlumno" onfocus="this.select()" size="80" maxlength="180" value="<cfif isdefined("form.btnFiltraAlum") and isdefined("form.nombreAlumno") AND #form.nombreAlumno# NEQ "" ><cfoutput>#form.nombreAlumno#</cfoutput></cfif>"/></td>
            <td width="19%"><input name="filtro_Pid" type="text" id="filtro_Pid" onfocus="this.select()" size="30" maxlength="60" value="<cfif isdefined("form.btnFiltraAlum") and isdefined("form.filtro_Pid") AND #form.filtro_Pid# NEQ "" ><cfoutput>#form.filtro_Pid#</cfoutput></cfif>" /></td>
          </tr>
          <tr>
            <td class="subTitulo">Nivel</td>
            <td class="subTitulo">Grado</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
			<select name="FNcodigo" id="FNcodigo" tabindex="5" onChange="javascript: cargarGrados(this, this.form.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true)">
    	      <option value="-1">Todos</option>
	          <cfoutput query="rsNiveles"> 
            	<option value="#Ncodigo#" <cfif isdefined("Form.FNcodigo") AND (Form.FNcodigo EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
          	</cfoutput> 
		  </select> 
			</td>
            <td>
				<select name="FGcodigo" id="FGcodigo" tabindex="5">
					<cfoutput query="rsGrado"> 
						<option value="#Codigo#" >#Gdescripcion#</option>
					</cfoutput> 
				</select>
			</td>
            <td>&nbsp;</td>
          </tr>		  
        </table>
      </td>
		</tr>
		<tr>
		  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr class="tituloListas"> 
				  <td width="59%" class="tituloListas">Nombre</td>
				  <td width="41%" class="tituloListas">Identificaci&oacute;n</td>
				</tr>
	
				<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 	  
				  <tr class=<cfif #conlis.CurrentRow# MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #conlis.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
					<td>
  						<a href="javascript:Asignar(#conlis.Ecodigo#,'#JSStringFormat(conlis.Nombre)#');">
							#conlis.Nombre#
						</a>			
					</td>
					<td>
  						<a href="javascript:Asignar(#conlis.Ecodigo#,'#JSStringFormat(conlis.Nombre)#');">   
							#conlis.Pid#
						</a>			
					</td>
				  </tr>
				 </cfoutput>  
			  <tr> 
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			</table></td>
		</tr>
		<tr>
		  <td>
			<!--- Botones de la lista --->
				<table border="0" width="50%" align="center">
				  <cfoutput> 
					<tr> 
					  <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
						  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../Imagenes/First.gif" border=0></a> 
						</cfif> </td>
					  <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
						  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../Imagenes/Previous.gif" border=0></a> 
						</cfif> </td>
					  <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
						  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../Imagenes/Next.gif" border=0></a> 
						</cfif> </td>
					  <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
						  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../Imagenes/Last.gif" border=0></a> 
						</cfif> </td>
					</tr>
				  </cfoutput> 
			  </table>	  
		  </td>
		</tr>
	  </table>
	</form>
	
	<script language="JavaScript" type="text/JavaScript">
		obtenerGrados(document.conlis);
		cargarGrados(document.conlis.FNcodigo, document.conlis.FGcodigo, '<cfif isdefined("Form.FGcodigo") AND Form.FGcodigo NEQ "-1"><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true);
	</script>	
</body>
</html>