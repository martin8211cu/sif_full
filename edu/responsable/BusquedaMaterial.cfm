<cfinclude template="../Utiles/general.cfm">
<cfif isdefined("Url.btnGenerar") and not isdefined("Form.btnGenerar")>
		<cfparam name="Form.btnGenerar" default="#Url.btnGenerar#">
	</cfif> 
	<cfif isdefined("url.atributo") and not isdefined("Form.atributo")>
		<cfparam name="Form.atributo" default="#url.atributo#">
	</cfif>
	<cfif isdefined("url.valor_atributo") and not isdefined("Form.valor_atributo")>
		<cfparam name="Form.valor_atributo" default="#url.valor_atributo#">
	</cfif>
	<cfif isdefined("url.valor") and not isdefined("Form.valor")>
		<cfparam name="Form.valor" default="#url.valor#">
	</cfif>

	<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
		<cfparam name="Form.codigo" default="#Url.codigo#">
	</cfif> 
	<cfif isdefined("url.id_documento") and not isdefined("Form.id_documento")>
		<cfparam name="Form.id_documento" default="#url.id_documento#">
	</cfif>
	<cfif isdefined("url.tipo") and not isdefined("Form.tipo")>
		<cfparam name="Form.tipo" default="#url.tipo#">
	</cfif>
	<cfif isdefined("url.tipo_contenido") and not isdefined("Form.tipo_contenido")>
		<cfparam name="Form.tipo_contenido" default="#url.tipo_contenido#">
	</cfif>
	<cfif isdefined("Url.CDfecha") and not isdefined("Form.CDfecha")>
		<cfparam name="Form.CDfecha" default="#Url.CDfecha#">
	</cfif> 
	<cfif isdefined("url.t_numero") and not isdefined("Form.t_numero")>
		<cfparam name="Form.t_numero" default="#url.t_numero#">
	</cfif>
	
	<cfif isdefined("url.texto") and not isdefined("Form.texto")>
		<cfparam name="Form.texto" default="#url.texto#">
	</cfif>
	<cfif isdefined("Url.E") and not isdefined("Form.cboAlumno")>
		<cfparam name="Form.cboAlumno" default="#Url.E#">
	</cfif> 
	<!---
	<cfif isdefined('form.CDfecha') and len(trim(form.CDfecha)) NEQ 0 and isdefined('form.CDfechaFin') and len(trim(form.CDfechaFin)) NEQ 0 >
		<cfif form.CDfecha GT form.CDfechaFin>
			<cfset fecha = "">
			<cfset fecha = form.CDfecha>
			<cfset form.CDfecha = form.CDfechaFin>
			<cfset form.CDfechaFin = #fecha#>
		</cfif>
	</cfif>
	--->
<html>
<head>
<title>Material Did&aacute;ctico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="../../css/edu.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.TxtNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 1px;
}
.BoxNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 1px;
    background-color: #E6E6E6;
}
.HdrNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 0px;
    border: 0px solid;
}
.CeldaTxt {
    text-indent: -9;
    margin-left: 12;
    margin-right: -4;
    margin-top: 0;
    margin-bottom: 0;
}
.CeldaHdr {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 14;
    font-weight:bold;
    color: #E6E6E6;
    background-color: #666666;
    vertical-align: middle;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
    text-align: center;
}
.CeldaNoCurso {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #E6E6E6;
    vertical-align: top;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
}
.CeldaCurso {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #C0C0C0;
    vertical-align: top;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
}
.CeldaFeriado {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: normal;
    background-color: #E6E6E6;
	vertical-align: top;
	border-right: 1px solid;
	border-top: 1px solid;
	margin: 0px;
	padding: 1px;
	color: #CC0000;
}
.CeldaRef {
    text-decoration:none; 
    color:#000000; 
    font-size: 10px;
    font-weight: normal;
}
.CeldaFechaRef {
    text-decoration:none; 
    color:#000000; 
    font-size: 11px;
    font-weight: normal;
}
.LinPar {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #E6E6E6;
    text-align: left;
    vertical-align: top;
    border: 0px;
    margin: 0px;
    padding: 1px;
}
.LinImpar {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #C0C0C0;
    text-align: left;
    vertical-align: top;
    border: 0px;
    margin: 0px;
    padding: 1px;
}
-->
</style>
</head>


<body style="background-color: #E6E6E6">

<cfinclude template="commonDocencia.cfm">
<cfif isdefined("Session.RolActual") and Session.RolActual EQ 6>
	<cfset rolAct = "edu.estudiante">
<cfelse>
	<cfset rolAct = "edu.encargado">
</cfif>

<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="#rolAct#"/>
</cfinvoke>

<cfquery datasource="#Session.Edu.DSN#" name="qryAlumnos">
  select distinct convert(varchar,a.Ecodigo) as Codigo, 
    Papellido1+' '+Papellido2+' '+Pnombre as Descripcion,
	convert(varchar,a.persona) as Persona
    from Alumnos a, PersonaEducativo pe, 
	<cfif isdefined("Session.RolActual") and Session.RolActual EQ 6>
	Estudiante e
	<cfelse>
	Encargado e, EncargadoEstudiante ee
	</cfif>
   where a.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and pe.persona  = a.persona
	 <cfif isdefined("Session.RolActual") and Session.RolActual EQ 6>
     and a.Ecodigo   = e.Ecodigo
     and e.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	 <cfelse>
     and a.Ecodigo   = ee.Ecodigo
     and ee.EEcodigo = e.EEcodigo
     and e.EEcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	 </cfif>
	 and a.Aretirado = 0
	 and exists( 
	 	select 1 from AlumnoCalificacionCurso acc, Curso c, PeriodoVigente pv
	 	where a.Ecodigo = acc.Ecodigo
		and acc.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and acc.CEcodigo = c.CEcodigo
		and acc.Ccodigo = c.Ccodigo
		and c.PEcodigo = pv.PEcodigo
		and c.SPEcodigo = pv.SPEcodigo
	 )
  order by Descripcion
</cfquery>

<cfif isdefined("url.E")>
	<cfif isdefined("Session.RolActual") and Session.RolActual eq 6>
		<cfquery name="rsEstSel" datasource="#Session.Edu.DSN#">
			select convert(varchar, Ecodigo) as Ecodigo
			from Estudiante
			where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
		</cfquery>
		<cfif rsEstSel.recordCount GT 0>
			<cfset Form.cboAlumno = rsEstSel.Ecodigo>
		<cfelse>
			<cfset Form.cboAlumno = "0">
		</cfif>
	<cfelse>
		<cfset Form.cboAlumno = url.E>
	</cfif>
	<cfset sbInitFromSession("cboAlumno", "-999",false)>
<cfelse>
	<cfset Form.cboAlumno = form.cboAlumno>
	<!--- <cfset sbInitFromSession("cboAlumno", "-999",true)> --->
</cfif>
		<!--- <cfquery datasource="#Session.Edu.DSN#" name="rsMateriaTipo">
			select convert(varchar,a.MTcodigo) + '|' + convert(varchar,b.id_documento)  as codigo, substring(a.MTdescripcion,1,60) as MTdescripcion
			from MateriaTipo a, DocumentoMateriaTipo b
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
			   and a.MTcodigo = b.MTcodigo
		</cfquery> --->
		<cfquery datasource="#Session.Edu.DSN#" name="rsMateriaTipo">
			select  distinct convert(varchar,MT.MTcodigo)  as codigo, 
			substring(MT.MTdescripcion,1,60) as MTdescripcion
			from Alumnos a , 
					 Curso c, 
					 AlumnoCalificacionCurso b, 
					 Materia d,  
					 Grado g, 
					 AlumnoCalificacionPerEval e, 
					 PeriodoEvaluacion f,
					 Nivel n,
					 Grupo gru ,
					 GrupoAlumno ga,
					 Materia Melec,
					 Curso Celec,
					 MateriaTipo MT,
					 DocumentoMateriaTipo DMT
				where n.CEcodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
				  and b.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#"> 
				  and a.Aretirado = 0
				  and a.Ecodigo = b.Ecodigo
				  and a.CEcodigo = b.CEcodigo 
				  and b.Ccodigo = c.Ccodigo 
				  and c.Mconsecutivo = d.Mconsecutivo 
				  and b.Ecodigo = e.Ecodigo 
				  and b.CEcodigo = e.CEcodigo 
				  and b.Ccodigo = e.Ccodigo 
				  and e.PEcodigo = f.PEcodigo 
				  and f.Ncodigo = d.Ncodigo 
				  and ((d.Melectiva = 'C') or (d.Melectiva = 'R') or (d.Melectiva = 'S'))
				  and d.Ncodigo = g.Ncodigo
				  and g.Ncodigo = n.Ncodigo

				  and gru.GRcodigo = ga.GRcodigo
				  and gru.Gcodigo = g.Gcodigo
				  and a.Ecodigo = ga.Ecodigo
					  
				  and gru.SPEcodigo = c.SPEcodigo
				
				  and b.ACCelectiva *= Celec.Ccodigo
				  and Celec.Mconsecutivo *= Melec.Mconsecutivo
			
				  and d.MTcodigo = MT.MTcodigo
				  and n.CEcodigo = MT.CEcodigo  
				  and DMT.MTcodigo =* MT.MTcodigo


			
		</cfquery>
		<!--- Rodolfo Jimenez Jara, Soluciones Integrales S.A., Costa Rica, America Central, 23/04/2003 --->
	
		<cfquery datasource="#Session.Edu.DSN#" name="rsMAAtributo">
			select convert(varchar,MAA.id_tipo) + '|' + convert(varchar,MAA.id_atributo) + '|' + MAA.tipo_atributo as id_atributo, 
				substring(MAA.nombre_atributo,1,35) as nombre_atributo, convert(varchar,MAA.id_atributo) as id_atrib 
				
			from MATipoDocumento MAT, MAAtributo MAA
			where MAT.id_tipo = MAA.id_tipo
			<!---   <cfif isdefined("form.tipo") and len(trim(form.tipo)) neq 0 >
			  	and MAA.id_tipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.tipo#">
			  </cfif> --->
		</cfquery>
	
		<cfquery datasource="#Session.Edu.DSN#" name="rsMAValorAtributo">
			select convert(varchar,MAVA.id_atributo) + '|' + convert(varchar,MAVA.id_valor) as id_valor, 
			convert(varchar,MAVA.id_valor) as valor_atrib, 
			substring(MAVA.contenido,1,35) as contenido
			from MAValorAtributo MAVA, MAAtributo MAA
			where MAVA.id_atributo = MAA.id_atributo
			 <!---  <cfif isdefined("form.id_atributo") and len(trim(form.id_atributo)) neq 0 >
			  	and MAVA.id_atributo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_atributo#">
			  </cfif> --->
		</cfquery>

		<cfquery datasource="#Session.Edu.DSN#" name="rsMATipoDocumento">
			select distinct convert(varchar,MAT.id_tipo)  as tipo, substring(MAT.nombre_tipo,1,35) as nombre_tipo
			from MATipoDocumento MAT, BibliotecaCentroE BCE
			where BCE.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
			  and MAT.id_biblioteca = BCE.id_biblioteca
		</cfquery>
		<cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>
		
		<script language="JavaScript1.4" type="text/javascript" src="../js/utilesMonto.js" >//</script>
		<script language="JavaScript1.4" type="text/javascript" src="../js/calendar.js" >//</script>
		<script language="JavaScript" type="text/JavaScript">  
			var MAT_id_tipo = new Array();
			var tipoText = new Array();
			
			var MAA_id_tipo = new Array();
			var MAA_id_atributo = new Array();
			var MAA_tipo_atributo = new Array();
			var AtributoText = new Array();
			
			var MAVA_id_tipo = new Array();
			var MAVA_id_atributo = new Array();
			var MAVAAtributoText = new Array();
			
			function obtenerTipoDocumento(f) {
				//var f = document.frmActividades;
				//alert("f es:"+f.value);
				//alert("tipo es:"+document.frmActividades.tipo);
				//alert("f.tipo.length es:"+f.tipo.length);
				
					for(i=0; i<f.tipo.length; i++) {
						//var s = f.tipo.options[i].value.split("|");
						var s = f.tipo.options[i].value;
						//alert(s);
						// Códigos de los detalles
						MAT_id_tipo[i] = s; 
						//alert(MAT_id_tipo[i]);
						tipoText[i] = f.tipo.options[i].text;
					}
			}
			
			// Esta función únicamente debe ejecutarlo una vez
			function obtenerValorAtributo(f) {
				//alert("Entro 3");
				//select convert(varchar,MAVA.id_valor) + '|' +  convert(varchar,MAVA.id_atributo) as id_valor, 			
				for(i=0; i<f.valor.length; i++) {
					var s = f.valor.options[i].value.split("|");
					//alert("valor atributo es: "+s);
					// Códigos de los detalles
					MAVA_id_tipo[i] =  s[0];
					MAVA_id_atributo[i] = s[1];
					
					MAVAAtributoText[i] = f.valor.options[i].text;
				}
			}
			
			//select convert(varchar,MAA.id_tipo) + '|' + convert(varchar,MAA.id_atributo) + '|' + MAA.tipo_atributo as id_atributo,
			// Esta función únicamente debe ejecutarlo una vez
			function obtenerAtributo(f) {
				//alert("Entro 2");			
				for(i=0; i<f.atributo.length; i++) {
					var s = f.atributo.options[i].value.split("|");
					//alert(s);
					// Códigos de los detalles
					MAA_id_tipo[i] =  s[0];
					MAA_id_atributo[i] = s[1];
					MAA_tipo_atributo[i]= s[2];
					AtributoText[i] = f.atributo.options[i].text;
				}
			}
			
			
			function cargarAtributo(csourceTipoAtrib, ctarget, vdefault, t){
				// Limpiar Combo
				for (var i=ctarget.length-1; i >=0; i--) {
					ctarget.options[i]=null;
				}
				var kNv_id_tipo = csourceTipoAtrib.value;
				var j = 0;
				//alert ("kNv_id_tipo es:"+kNv_id_tipo);
				if (t) {
					var nuevaOpcion = new Option("(- No interesa -)","-1");
					ctarget.options[j]=nuevaOpcion;
					j++;
				}
				for (var i=0; i<MAA_id_tipo.length; i++) {
					if (MAA_id_tipo[i] == kNv_id_tipo ) {
						//nuevaOpcion = new Option(AtributoText[i],MAA_id_atributo[i] + '|' + MAA_tipo_atributo[i]);
						nuevaOpcion = new Option(AtributoText[i],MAA_id_atributo[i]);
						ctarget.options[j]=nuevaOpcion;
						if (vdefault != null && MAA_id_atributo[i] == vdefault) {
							ctarget.selectedIndex = j;
						}
						j++;
					}
				}
			}
			
			function cargarValor(csourceValAtrib, ctarget, vdefault, t){
				// Limpiar Combo
				for (var i=ctarget.length-1; i >=0; i--) {
					ctarget.options[i]=null;
				}
				var h = csourceValAtrib.value.split("|");			
				var kNv_Val_id_tipo = h[0];
				var kNv_val_valor = h[1];
				//alert("kNv_Val_id_tipo es: "+kNv_Val_id_tipo); 
				//var kNv_Val_id_tipo = csourceValAtrib.value;
				
				var j = 0;
				if (t) {
					var nuevaOpcion = new Option("(- No interesa -)","-1");
					ctarget.options[j]=nuevaOpcion;
					j++;
				}
				for (var i=0; i<MAVA_id_tipo.length; i++) {
						//alert("MAVA_id_tipo es: " + MAVA_id_tipo[i]); alert("kNv_Val_id_tipo es: "+kNv_Val_id_tipo);
					if (MAVA_id_tipo[i] == kNv_Val_id_tipo ) {
						nuevaOpcion = new Option(MAVAAtributoText[i],MAVA_id_atributo[i] );
						ctarget.options[j]=nuevaOpcion;
						if (vdefault != null && MAVA_id_atributo[i] == vdefault) {
							ctarget.selectedIndex = j;
						}
						j++;
					}
				}
			}

		</script>
		<!---------------------------------------------------------------------------------- --->
<script language="JavaScript" src="/cfmx/edu/docencia/commonDocencia1_00.js"></script>
<script language="JavaScript" src="consultarActividades1_00.js"></script>
<script language="JavaScript" src="../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function ocultar(obj){
		var valor1= document.getElementById("valor1");
		var valor2= document.getElementById("valor2");
		var valor3= document.getElementById("valor3");
		var valor4= document.getElementById("valor4");
		var valor5= document.getElementById("valor5");
		var valor6= document.getElementById("valor6");
		var valor7= document.getElementById("valor7");
		var valor8= document.getElementById("valor8");
		var valor9= document.getElementById("valor9");
		var valor10= document.getElementById("valor10");
		
		valor1.style.display = "none";
		valor2.style.display = "none";
		valor3.style.display = "none";
		valor4.style.display = "none";
		valor5.style.display = "none";
		valor6.style.display = "none";
		valor7.style.display = "none";
		valor8.style.display = "none";
		valor9.style.display = "none";
		valor10.style.display = "none";

			
		for(i=0; i<MAA_id_atributo.length; i++) {
			
			if (MAA_id_atributo[i] == obj.value) {
				//alert(MAA_tipo_atributo[i]);
				//alert(obj.value);
				if(MAA_tipo_atributo[i] == 'V'){
					
					valor1.style.display = "";
					valor2.style.display = "";
					valor3.style.display = "none";
					valor4.style.display = "none";	
					valor5.style.display = "none";
					valor6.style.display = "none";
					valor7.style.display = "none";
					valor8.style.display = "none";
					valor3.value = "";
					valor4.value = "";
					valor5.value = "";
					valor6.value = "";
					valor7.value = "";
					valor8.value = "";
					valor9.value = "";
					valor10.value = "";
					valor1.disabled = false;
					valor2.disabled = false;
					valor3.disabled = true;
					valor4.disabled = true;
					valor5.disabled = true;
					valor6.disabled = true;
					valor7.disabled = true;
					valor8.disabled = true;
					valor9.disabled = true;
					valor10.disabled = true;
				}else if (MAA_tipo_atributo[i] == 'F'){
					valor1.style.display = "none";
					valor2.style.display = "none";
					valor3.style.display = "";
					valor4.style.display = "";	
					valor5.style.display = "none";
					valor6.style.display = "none";
					valor7.style.display = "none";
					valor8.style.display = "none";
					valor9.style.display = "";
					valor10.style.display = "";	
					valor1.value = "";
					valor2.value = "";
					valor5.value = "";
					valor6.value = "";
					valor7.value = "";
					valor8.value = "";
					valor1.disabled = true;
					valor2.disabled = true;
					valor3.disabled = false;
					valor4.disabled = false;
					valor5.disabled = true;
					valor6.disabled = true;
					valor7.disabled = true;
					valor8.disabled = true;
					valor9.disabled = false;
					valor10.disabled = false;
				}else if (MAA_tipo_atributo[i] == 'T'){
					valor1.style.display = "none";
					valor2.style.display = "none";
					valor3.style.display = "none";
					valor4.style.display = "none";
					valor5.style.display = "none";
					valor6.style.display = "none";
					valor7.style.display = "";
					valor8.style.display = "";
					valor9.style.display = "none";
					valor10.style.display = "none";					
					valor1.disabled = true;
					valor2.disabled = true;
					valor3.disabled = true;
					valor4.disabled = true;
					valor5.disabled = true;
					valor6.disabled = true;
					valor7.disabled = false;
					valor8.disabled = false;
					valor9.disabled = true;
					valor10.disabled = true;
					valor1.value = "";
					valor2.value = "";
					valor3.value = "";
					valor4.value = "";
					valor5.value = "";
					valor6.value = "";
					valor9.value = "";
					valor10.value = "";
					
				}else if (MAA_tipo_atributo[i] == 'N'){
					valor1.style.display = "none";
					valor2.style.display = "none";
					valor3.style.display = "none";
					valor4.style.display = "none";
					valor5.style.display = "";
					valor6.style.display = "";
					valor7.style.display = "none";
					valor8.style.display = "none";
					valor9.style.display = "none";
					valor10.style.display = "none";
					valor1.value = "";
					valor2.value = "";
					valor3.value = "";
					valor4.value = "";
					valor7.value = "";
					valor8.value = "";
					valor9.value = "";
					valor10.value = "";
					valor1.disabled = true;
					valor2.disabled = true;
					valor3.disabled = true;
					valor4.disabled = true;
					valor5.disabled = false;
					valor6.disabled = false;
					valor7.disabled = true;
					valor8.disabled = true;
					valor9.disabled = true;
					valor10.disabled = true;
				}
			}
		}
	}
</script>
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">
		<form name="frmActividades" method="post" action="BusquedaMaterial.cfm">
			<input name="MTcodigo" id="MTcodigo" type="hidden" value="">
			<input name="id_documento" id="id_documento" type="hidden" value="">
			<input name="tipo_atributo" id="tipo_atributo" type="hidden" value="">
			<input name="id_valor" id="id_valor" type="hidden" value="">
  <table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
    <tr> 
      <td colspan="6"></td>
    </tr>
    <tr  align="center"> 
      <td colspan="6" align="center"><font size="2"><strong>Material Did&aacute;ctico</strong></font></td>
    </tr>
    <tr> 
      <td colspan="6" align="center"><font size="2"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></font></td>
    </tr>
    <tr> 
      <td colspan="6">&nbsp;</td>
    </tr>
    <tr> 
      <td>Alumno</td>
      <td align="left" ><select name="cboAlumno"
                style="font:10px Verdana, Arial, Helvetica, sans-serif;"
                onChange="fnReLoad();">
          <cfset LvarSelected="0">
          <cfset LvarFirst="">
          <cfoutput query="qryAlumnos"> 
            <cfif currentRow eq 1>
              <cfset LvarFirst=Codigo>
              <cfset LvarPersonaAlumno="#Persona#">
            </cfif>
            <option value="#Codigo#"
	  <cfif #form.cboAlumno# eq #Codigo#> selected<cfset LvarSelected="1"><cfset LvarPersonaAlumno="#Persona#">
	  </cfif>>#Descripcion#</option>
          </cfoutput> 
          <cfif #LvarSelected# eq "0">
            <cfif LvarFirst neq "">
              <cfset form.cboAlumno=LvarFirst>
              <cfelse>
              <cfset form.cboAlumno="-999">
              <cfset LvarPersonaAlumno="-999">
            </cfif>
          </cfif>
        </select></td>
      <td align="left" >Tipo de Materia</td>
      <td align="left" ><select name="codigo" id="select2" >
          <option value="-1" <cfif isdefined("form.codigo") and form.codigo EQ "-1">selected</cfif>>(- 
          No interesa -)</option>
          <cfoutput query="rsMateriaTipo"> 
            <option value="#rsMateriaTipo.codigo#" <cfif isdefined('form.codigo') and form.codigo EQ '#rsMateriaTipo.codigo#'>selected</cfif>>#rsMateriaTipo.MTdescripcion#</option>
          </cfoutput> </select></td>
      <td >&nbsp;</td>
    </tr>
    <tr> 
      <td>Tipo de Documento</td>
      <td align="left" ><select name="tipo" id="select3" onChange="javascript:  cargarAtributo(this,this.form.atributo,'<cfif isdefined('Form.atributo') AND Form.atributo NEQ '-1'><cfoutput>#Form.atributo#</cfoutput></cfif>',true); ocultar(this.form.atributo); cargarValor(this.form.atributo,this.form.valor,'<cfif isdefined('Form.valor') AND Form.valor NEQ '-1'><cfoutput>#Form.valor#</cfoutput></cfif>',true);">> 
          <option value="-1" <cfif isdefined("form.tipo") and form.tipo EQ "-1">selected</cfif>>(- 
          No interesa -)</option>
          <cfoutput query="rsMAtipoDocumento"> 
            <option value="#rsMAtipoDocumento.tipo#"<cfif isdefined('form.tipo') and form.tipo EQ rsMAtipoDocumento.tipo>selected</cfif>>#rsMAtipoDocumento.nombre_tipo#</option>
          </cfoutput></select> </td>
      <td align="left" nowrap >Tipo de Contenido</td>
      <td align="left" nowrap ><select name="tipo_contenido" id="select4">
          <option value="-1" <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "-1">selected</cfif>>(- 
          No interesa -)</option>
          <option value="I"  <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "I">selected</cfif>>Imagen</option>
          <option value="D"  <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "D">selected</cfif>>Documento</option>
          <option value="L"  <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "L">selected</cfif>>Link</option>
          <option value="T"  <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "T">selected</cfif>>Texto</option>
        </select> </td>
      <td >&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap>Atributo</td>
      <td nowrap><select name="atributo" id="select5"  onChange="javascript: ocultar(this.form.atributo); cargarValor(this,this.form.valor,'<cfif isdefined('Form.valor') AND Form.valor NEQ '-1'><cfoutput>#Form.valor#</cfoutput></cfif>',true);" >
          <!---  <option value="-1" <cfif isdefined("form.atributo") and form.atributo EQ "-1">selected</cfif>>- (No Interesa) -</option> --->
          <cfoutput query="rsMAAtributo"> 
            <option value="#rsMAAtributo.id_atributo#"<cfif isdefined('form.atributo') and form.atributo EQ '#rsMAAtributo.id_atrib#'>selected</cfif>>#rsMAAtributo.nombre_atributo#</option>
          </cfoutput> </select></td>
      <td nowrap> <div id="valor1" style="display: none;">Valor</div>
        <div id="valor4" style="display: none;">Fecha Inicial </div>
        <div id="valor5" style="display: none;">Número</div>
        <div id="valor7" style="display: none;">Texto</div></td>
      <td nowrap><div id="valor2" style="display: none;"> 
          <select name="valor" id="select">
            <cfoutput query="rsMAValorAtributo"> 
              <option value="#rsMAValorAtributo.id_valor#"<cfif isdefined('form.valor') and form.valor EQ '#rsMAValorAtributo.valor_atrib#'>selected</cfif>>#rsMAValorAtributo.contenido#</option>
            </cfoutput> 
          </select>
        </div>
        <div id="valor3" style="display: none;"> <a href="#"> 
          <input name="CDfecha" onFocus="this.select()" type="text" value="<cfif isdefined("form.CDfecha") and len(trim(#form.CDfecha#)) NEQ 0 ><cfoutput>#form.CDfecha#</cfoutput></cfif>" onBlur="javascript: onblurdatetime(this)"  size="12" maxlength="10" >
          <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.frmActividades.CDfecha');"> 
          </a> </div>
        <div id="valor6" style="display: none;"> 
          <input name="t_numero" align="left" type="text" id="t_numero" size="8" maxlength="8" value="<cfif isdefined("form.t_numero")><cfoutput>#form.t_numero#</cfoutput></cfif>" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
        </div>
        <div id="valor8" style="display: none;"> 
          <input name="texto" type="text"  onFocus="this.select()"  value="<cfif isdefined("form.texto")><cfoutput>#form.texto#</cfoutput></cfif>" size="30" maxlength="255" alt="Texto del documento">
        </div></td>
      <td nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td nowrap><div id="valor9" style="display: none;">Fecha Final</div></td>
      <td nowrap> <div id="valor10" style="display: none;"> <a href="#"> 
          <input name="CDfechaFin" onFocus="this.select()" type="text" value="<cfif isdefined("form.CDfechaFin") and len(trim(#form.CDfechaFin#)) NEQ 0 ><cfoutput>#form.CDfechaFin#</cfoutput></cfif>" onBlur="javascript: onblurdatetime(this)"  size="12" maxlength="10" >
          </a> <a href="#"><img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.frmActividades.CDfechaFin');"> 
          </a> </div></td>
      <td colspan="2" rowspan="2" align="center" valign="middle"><input name="btnGenerar" type="submit" id="btnGenerar" value="Buscar" > 
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4">
						<cfif isdefined("form.btnGenerar")>
							<cfinclude template="formBusquedaMaterial.cfm">
						</cfif>
					</td>
				</tr>
			</table>

		</form>

			<script language="JavaScript" type="text/javascript" >
				obtenerTipoDocumento(document.frmActividades);
				obtenerAtributo(document.frmActividades);
				cargarAtributo(document.frmActividades.tipo,document.frmActividades.atributo, '<cfif isdefined("Form.atributo") AND Form.atributo NEQ "-1"><cfoutput>#Form.atributo#</cfoutput></cfif>', true);	
				obtenerValorAtributo(document.frmActividades);
				//cargarValorAtributo
				cargarValor(document.frmActividades.atributo,document.frmActividades.valor, '<cfif isdefined("Form.valor") AND Form.valor NEQ "-1"><cfoutput>#Form.valor#</cfoutput></cfif>', true);	
				ocultar(document.frmActividades.atributo);
			</script>
			<script language="JavaScript">
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("frmActividades");
							
				ocultar(document.frmActividades.atributo);		
			</script>
			
</body>
</html>