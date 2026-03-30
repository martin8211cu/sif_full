<cfinclude template="/edu/Utiles/general.cfm">
<html>
<head>
<title>Aplicación de Grados a Materias Sustitutivas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="/cfmx/edu/css/sif.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfif isdefined("Url.Gcodigo") and not isdefined("Form.Gcodigo")>
	<cfparam name="Form.Gcodigo" default="#Url.Gcodigo#">
<cfelse>
	
</cfif>
<cfif isdefined("Url.Gnombre") and not isdefined("Form.Gnombre")>
	<cfparam name="Form.Gnombre" default="#Url.Gnombre#">
</cfif>

<cfif not isdefined("Form.Chk") and isdefined("Form.btnAplicar")>
	<cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
		set nocount on
		delete GradoSustitutivas 
		where Gcodigo in (#form.Cual_Grupo#)  
		  and Ncodigo in (#form.Cual_Nivel#)  
		  and Mconsecutivo in (#form.Cual_Materia#)  
		set nocount off
	</cfquery>
</cfif>
<cfif isdefined("Form.Chk")>

	<cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
		set nocount on
		delete GradoSustitutivas 
		where Gcodigo in (#form.Cual_Grupo#)  
		  and Ncodigo in (#form.Cual_Nivel#)  
		  and Mconsecutivo in (#form.Cual_Materia#)  
		set nocount off
	</cfquery>

 	<cfset a=ListToArray(Form.Chk,',')>
	<cfloop index="i" from="1" to="#ArrayLen(a)#">
		<cfset b = ListToArray(a[i],'|')>
		 <cfset Gcodigo = b[1]>
		<cfset Ncodigo = b[2]>
		<cfset Mconsecutivo = b[3]>
		
		<!--- <cfoutput>#Gcodigo#, #Ncodigo#,#Hcodigo#</cfoutput> --->
		<cfquery name="ABC_GradoAplica" datasource="#Session.Edu.DSN#">
				set nocount on
				insert GradoSustitutivas (Gcodigo, Ncodigo, Mconsecutivo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Gcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ncodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mconsecutivo#">
							)
				set nocount off
		</cfquery>
	</cfloop>
	 <script language="JavaScript">
		window.close();
	</script>
</cfif>
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td></td>
              </tr>
              <tr> 
                
    <td align="center"> 
      <form name="filtros" action="ConlisAplicaGradoSustitutivas.cfm" method="post">
        &nbsp; <strong>Grado:</strong> <cfoutput>#form.Gnombre#</cfoutput> 
      </form></td>
              </tr>
              <tr> 
                <td><strong> &nbsp;&nbsp;&nbsp; 
                  <input name="chkTodos" type="checkbox" value="" border="1" onClick="javascript:Marcar(this);">
                  Seleccionar Todos</strong></td>
              </tr>
              <tr> 
                <td>
					<form name="lista" method="post" action="ConlisAplicaGradoSustitutivas.cfm">
					<input type="hidden" name="Gcodigo" value="<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>">
					<input type="hidden" name="Gnombre" value="<cfif isdefined("Form.Gnombre")><cfoutput>#Form.Gnombre#</cfoutput></cfif>">
					<input name="Cual_Grupo" type="hidden" id="Cual_Grupo" value="">
					<input name="Cual_Nivel" type="hidden" id="Cual_Nivel" value="">
					<input name="Cual_Materia" type="hidden" id="Cual_Materia" value="">
					<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
                    	<cfset Pagenum_lista = #Form.Pagina#>
                  	</cfif> 
					<cfinvoke 
						 component="edu.Componentes.pListas"
						 method="pListaEdu"
						 returnvariable="pListaEduRet">
							<cfinvokeargument name="tabla" value="Materia a, Nivel b, GradoSustitutivas c"/>
							<!--- <cfinvokeargument name="columnas" value="convert(varchar, c.Mconsecutivo) as Mconsecutivo, convert(varchar, c.Melectiva) as Melectiva , substring(a.Mnombre,1,50) as Mnombre, a.Mhoras, a.Mcreditos, convert(varchar, a.Ncodigo) as Ncodigo, convert(varchar, a.Gcodigo) as Gcodigo, convert(varchar, isnull(c.Melectiva,1)) as checked"/> --->
							<cfinvokeargument name="columnas" value="convert(varchar, a.Mconsecutivo) as Mconsecutivo, convert(varchar, a.Melectiva) as Melectiva , substring(a.Mnombre,1,50) as Mnombre, a.Mhoras, a.Mcreditos, convert(varchar, a.Ncodigo) as Ncodigo, convert(varchar, a.Gcodigo) as Gcodigo, convert(varchar, c.Gcodigo)+'|'+convert(varchar, c.Ncodigo)+'|'+convert(varchar, c.Mconsecutivo) as checked"/>

							<cfinvokeargument name="desplegar" value="Mnombre, Mhoras, Mcreditos"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Horas, Cr&eacute;ditos"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="filtro" value="b.CEcodigo = #Session.Edu.CEcodigo# and a.Ncodigo = b.Ncodigo and a.Melectiva = 'S' and a.Mconsecutivo *= c.Mconsecutivo order by a.Mnombre"/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="N,N,N"/>
							<cfinvokeargument name="irA" value="ConlisAplicaGradoSustitutivas.cfm"/>
							<cfinvokeargument name="botones" value=""/>
							<cfinvokeargument name="checkboxes" value="S"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="maxrows" value="17"/>
							<cfinvokeargument name="incluyeForm" value="false"/>
							<cfinvokeargument name="formName" value="lista"/>
							<cfinvokeargument name="keys" value="Gcodigo,Ncodigo,Mconsecutivo"/>
							<cfinvokeargument name="checkedcol" value="checked"/>
							<cfinvokeargument name="botones" value="Aplicar"/>
						</cfinvoke>
		
						 <script language="JavaScript">
						 	if (document.lista.chk != null) {
								if (document.lista.chk.value != null) {
									if (document.lista.chk.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
								} else {
									
									for (var counter = 0; counter < document.lista.chk.length; counter++) {
										var a = document.lista.chk[counter].value.split("|");
										
										var Gcodigo = a[0];
										var Ncodigo = a[1];
										var Mconsecutivo = a[2];
										
										document.lista.Cual_Grupo.value += Gcodigo + ",";
										document.lista.Cual_Nivel.value += Ncodigo + ",";
										document.lista.Cual_Materia.value += Mconsecutivo + ",";
									}
									if (document.lista.Cual_Grupo.value != "") {
										document.lista.Cual_Grupo.value = document.lista.Cual_Grupo.value.substring(0,document.lista.Cual_Grupo.value.length-1);
									}
									if (document.lista.Cual_Nivel.value != "") {
										document.lista.Cual_Nivel.value = document.lista.Cual_Nivel.value.substring(0,document.lista.Cual_Nivel.value.length-1);
									}
									if (document.lista.Cual_Materia.value != "") {
										document.lista.Cual_Materia.value = document.lista.Cual_Materia.value.substring(0,document.lista.Cual_Materia.value.length-1);
									}
									
									
									//alert(document.lista.Cual_Grupo.value);
								}
							}
						</script>
					</form>
				 </td>
              </tr>
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
			
									  
			  </script>
            </table>

</body>
</html>