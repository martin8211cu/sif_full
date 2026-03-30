<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 25 de febrero del 2006
	Motivo: Actualización de fuentes de educación a nuevos estándares de Pantallas y Componente de Listas.
 --->
<cfinclude template="/edu/Utiles/general.cfm">

<html>
<head>
<title>Aplicación de Horario a Grados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfif isdefined("Url.Hcodigo") and not isdefined("Form.Hcodigo")>
	<cfset form.Hcodigo = Url.Hcodigo>
</cfif>
<cfif isdefined("Form.btnAplicar")>
	<cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
		delete HorarioAplica 
		where Hcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Hcodigo#">
		  and Gcodigo in (#form.Cual_Grupo#)  
	</cfquery>
	<cfif isdefined("Form.Chk")>
		<cfset a=ListToArray(Form.Chk,',')>
		<cfloop index="i" from="1" to="#ArrayLen(a)#">
			<cfset b = ListToArray(a[i],'|')>
			 <cfset Gcodigo = b[1]>
			<cfset Ncodigo = b[2]>
			<cfquery name="ABC_HorarioAplica" datasource="#Session.Edu.DSN#">
				insert into HorarioAplica (Gcodigo, Ncodigo, Hcodigo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Gcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ncodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Hcodigo#">
							)
			</cfquery>
		</cfloop>
		 <script language="JavaScript">
			window.close();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfquery name="rsHorario" datasource="#Session.Edu.DSN#">
		select Hnombre 
		from HorarioTipo
		where Hcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hcodigo#">
	</cfquery>
</cfif>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
    		<td align="center"> 
				<form name="lista" method="post" action="ConlisAplicaGradoAhorario.cfm">
					<input type="hidden" name="Hcodigo" 
						value="<cfif isdefined("Form.Hcodigo")><cfoutput>#Form.Hcodigo#</cfoutput></cfif>">
					<input name="Cual_Grupo" type="hidden" id="Cual_Grupo" value="">
					<cfquery name="rsGrados" datasource="#session.Edu.DSN#">
						select -1 as value, '-- Todos --' as description
						union
						select b.Gcodigo as value, b.Gdescripcion  as description
						from Nivel a, Grado b 
						where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
						  and a.Ncodigo = b.Ncodigo 
						 order by value
					</cfquery>
					<cfset navegacion = "">
					<cfif isdefined("Form.Hcodigo") and Form.Hcodigo NEQ ''>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Hcodigo=" & Form.Hcodigo>
					</cfif>
					<cfinvoke 
					 component="edu.Componentes.pListas"
					 method="pListaEdu"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 		  	value="Grado b, Nivel a, HorarioAplica c"/>
						<cfinvokeargument name="columnas" 		value="convert(varchar, b.Gcodigo) as Gcodigo, 
																convert(varchar, b.Ncodigo) as Ncodigo, 
																substring(a.Ndescripcion,1,50) as Ndescripcion, 
																b.Gdescripcion, 
																convert(varchar,c.Gcodigo)+'|'+convert(varchar,c.Ncodigo) as checked"/>
						<cfinvokeargument name="desplegar" 		value="Gdescripcion"/>
						<cfinvokeargument name="etiquetas" 		value="Grados"/>
						<cfinvokeargument name="formatos" 		value="S"/>
						<cfinvokeargument name="filtro" 		value=" a.CEcodigo = #Session.Edu.CEcodigo# 
																		and b.Gcodigo *= c.Gcodigo 
																		and b.Ncodigo *= c.Ncodigo 
																		and c.Hcodigo = #Form.Hcodigo# 
																		and a.Ncodigo = b.Ncodigo 
																		order by a.Norden, b.Gorden "/>
						<cfinvokeargument name="filtrar_por"  	value="b.Gcodigo"/>
						<cfinvokeargument name="align" 			value="left"/>
						<cfinvokeargument name="ajustar" 		value="N"/>
						<cfinvokeargument name="irA" 			value="ConlisAplicaGradoAhorario.cfm"/>
						<cfinvokeargument name="showlink"		value="false"/>
						<cfinvokeargument name="cortes" 		value="Ndescripcion"/>
						<cfinvokeargument name="checkboxes" 	value="S"/>
						<cfinvokeargument name="debug" 			value="N"/>
						<cfinvokeargument name="maxrows" 		value="10"/>
						<cfinvokeargument name="incluyeForm" 	value="false"/>
						<cfinvokeargument name="formName" 		value="lista"/>
						<cfinvokeargument name="keys" 			value="Gcodigo, Ncodigo "/>
						<cfinvokeargument name="checkedcol" 	value="checked"/>
						<cfinvokeargument name="botones" 		value="Aplicar, Cerrar"/>
						<cfinvokeargument name="conexion" 		value="#session.Edu.DSN#"/>
						<cfinvokeargument name="rsGdescripcion"	value="#rsGrados#"/>
						<cfinvokeargument name="mostrar_filtro"	value="true"/>
						<cfinvokeargument name="filtrar_automatico"	value="true"/>
						<cfinvokeargument name="navegacion"		value="#navegacion#">
						<cfinvokeargument name="debug"			value="N"/>
					</cfinvoke>
					
					 <script language="JavaScript">
						if (document.lista.chk != null) {
							if (document.lista.chk.value != null) {
								if (document.lista.chk.checked) 
									document.lista.chk.checked = true; 
								else document.lista.chk.checked = false;
								var a = document.lista.chk.value.split("|");
								var Gcodigo = a[0];
								document.lista.Cual_Grupo.value += Gcodigo ;
							} else {
								for (var counter = 0; counter < document.lista.chk.length; counter++) {
									var a = document.lista.chk[counter].value.split("|");
									var Gcodigo = a[0];
									document.lista.Cual_Grupo.value += Gcodigo + ",";
								}
								if (document.lista.Cual_Grupo.value != "") {
									document.lista.Cual_Grupo.value = document.lista.Cual_Grupo.value.substring(0,document.lista.Cual_Grupo.value.length-1);
								}
							}
						}
					</script>
				</form>
			</td>
		</tr>
	</table>
	<script language="JavaScript1.2">
		function Marcar(c) {
			if (document.lista.chk != null) { //existe?
				if (document.lista.chk.value != null) {// solo un check
					if (c.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
				}
				else {
					if (c.checked) {
						for (var counter = 0; counter < document.lista.chk.length; counter++)
						{
							if ((!document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
								{  document.lista.chk[counter].checked = true;}
						}
						if ((counter==0)  && (!document.lista.chk.disabled)) {
							document.lista.chk.checked = true;
						}
					}
					else {
						for (var counter = 0; counter < document.lista.chk.length; counter++)
						{
							if ((document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
								{  document.lista.chk[counter].checked = false;}
						};
						if ((counter==0) && (!document.lista.chk.disabled)) {
							document.lista.chk.checked = false;
						}
					};
				}
			}
		}

		function LimpiarFiltros(f) {
			f.Gcodigo.selectedIndex = 0;
		}
		function funcCerrar(){
			window.close();
		}
	
							  
	</script>

</body>
</html>