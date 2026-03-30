<cfparam name="URL.AClaId"						default="-1">

<cfif isdefined('form.filtro_SNnombre')and len(trim(form.filtro_SNnombre)) >
	<cfset SNnombre = #form.filtro_SNnombre#>
</cfif>	
<cfif isdefined('form.filtro_SNnumero')and len(trim(form.filtro_SNnumero)) >
	<cfset SNnumero = #form.filtro_SNnumero#>
</cfif>	

<cfset modo="ALTA">
<cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo)) and isdefined("form.ID") and len(trim(form.ID))>
	<cfset modo="CAMBIO">
</cfif>
   
<cfif modo NEQ 'ALTA'>
    <cfquery name="rsClasificacion" datasource="#Session.DSN#">		
        select 	a.id, a.Ecodigo, a.SNcodigo, a.CCid, a.AClaId,a.Ccodigo, a.nivel, a.ts_rversion,cl.ACdescripcion,cl.ACcodigo,cl.ACcodigodesc,cl.ACdescripcion,
            cat.ACcodigo as ACcodigoCat, cat.ACcodigodesc as ACcodigodescCat, cat.ACdescripcion as ACdescripcionCat,
            b.Ccodigoclas, b.Cdescripcion, b.Cnivel,
            c.CCcodigo, c.CCdescripcion, c.CCnivel, a.Cid
        from ClasificacionItemsProv a
            left outer join Clasificaciones b
                on a.Ccodigo = b.Ccodigo
                and a.Ecodigo = b.Ecodigo
            left outer join CConceptos c
                on a.CCid = c.CCid
                and a.Ecodigo =c.Ecodigo
            left outer join AClasificacion cl 
                on cl.AClaId = a.AClaId
                and cl.Ecodigo = a.Ecodigo 
            left outer join ACategoria cat
                on cat.Ecodigo = cl.Ecodigo and  cat.ACcodigo = cl.ACcodigo
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
        
        <cfif isdefined ("form.CCid") and len(trim(form.CCid))>
            and a.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
        </cfif>
        <cfif isdefined ("form.Ccodigo") and len(trim(form.Ccodigo))>
            and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
        </cfif>
        
        <cfif isdefined ("form.AClaId") and len(trim(form.AClaId))>
            and a.AClaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AClaId#">
        </cfif>
    </cfquery>

    <cfquery name="rsClase" datasource="#session.DSN#">
        select AClaId, ACcodigodesc, ACdescripcion, ACcodigo
        from AClasificacion
        where AClaId =  #url.AClaId#
          and Ecodigo = #session.Ecodigo#
    </cfquery>
	<cfquery name="rsClategoria" datasource="#session.DSN#">
        select ACcodigo,ACcodigodesc,ACdescripcion
        from ACategoria
        where Ecodigo = #session.Ecodigo#
    </cfquery>
    
    <cfif isdefined("rsClasificacion.Cid") and rsClasificacion.Cid NEQ ''>
        <cfquery name="rsConceptoServicio" datasource="#session.DSN#">
            select Cid, Ccodigo, Cdescripcion
            from Conceptos
            where Ecodigo = #session.Ecodigo#
            and Cid = #rsClasificacion.Cid#
        </cfquery>
    </cfif>
</cfif>


<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form action="SQLClasificacionSocioNeg.cfm" method="post" name="form1" onSubmit="javascript: return FuncValidar()">
	<input type="hidden" name="id" value="<cfif modo NEQ 'ALTA'>#rsClasificacion.id#</cfif>">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr><td>&nbsp;</td></tr>

		<tr>
			<td align="right" nowrap><strong>Socio Negocio:</strong>&nbsp;</td>
			<td nowrap>
				<cfif modo neq 'ALTA' or isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
					<cf_sifsociosnegocios2 idquery="#form.SNcodigo#">
				<cfelse>
					<cf_sifsociosnegocios2>
				</cfif>
			</td>	
		</tr>
		<tr>
			<td align="right" nowrap><strong>Tipo Clasificaci&oacute;n:</strong>&nbsp;</td>
			<td nowrap>		
								
				<input name="tipo" type="radio" value="Ccodigo" onClick="javascript: FuncClasificacion();" <cfif modo NEQ 'ALTA' and rsClasificacion.Ccodigo NEQ '' >checked</cfif>><strong><label for="Ccodigo">Artículos</label></strong>
				<input name="tipo" type="radio" value="CCid" onClick="javascript: FuncClasificacion();" <cfif modo NEQ 'ALTA' and rsClasificacion.CCid NEQ ''>checked</cfif>><strong><label for="CCid">Servicios</label></strong>
				<input name="tipo" type="radio" value="AClaId" onClick="javascript: FuncClasificacion();" <cfif modo NEQ 'ALTA' and rsClasificacion.AClaId NEQ ''>checked</cfif>><strong><label for="AClaId">Activos</label></strong>
			</td>
		</tr>
		<tr>
			<td align="right"><div id="Clas" style="display: <cfif modo NEQ 'ALTA' and (rsClasificacion.Ccodigo NEQ '' or rsClasificacion.CCid NEQ '')>''<cfelse>none</cfif>;"><strong><label>Clasificación:</label></strong></div></td>
			<td>				
				<div id="Articulos" style="display: <cfif modo NEQ 'ALTA' and rsClasificacion.Ccodigo NEQ ''>''<cfelse>none</cfif>;">
					<cfif modo neq 'ALTA'>
						<cf_sifclasificacionarticulo query="#rsClasificacion#" form="form1" nivel="Cnivel">
					<cfelse>
						<cf_sifclasificacionarticulo form="form1">
					</cfif>
				</div>
				<div id="Servicios" style="display: <cfif modo NEQ 'ALTA' and rsClasificacion.CCid NEQ ''>''<cfelse>none</cfif> ;" >
					<cfif modo neq 'ALTA'>
						<cf_sifclasificacionconcepto query="#rsClasificacion#" id="CCid" name="CCcodigo">
					<cfelse>
						<cf_sifclasificacionconcepto id="CCid" name="CCcodigo" desc="CCdesc">
					</cfif>
				</div>
			</td>		
		</tr>
		<tr>
			<td align="right"><div id="Cat" style="display: <cfif modo NEQ 'ALTA'and  rsClasificacion.ACcodigo NEQ ''>''<cfelse>none</cfif>;"><strong><label>Categoría:</label></strong></div>
			<div id="Clas1" style="display: <cfif modo NEQ 'ALTA' and rsClasificacion.ACcodigo NEQ ''>''<cfelse>none</cfif>;"><strong><label>Clasificación:</label></strong></div></td>
			<td>				
			<div id="Categoria" style="display: <cfif modo NEQ 'ALTA' and rsClasificacion.ACcodigo NEQ ''>''<cfelse>none</cfif> ;" >
			<cfif modo neq 'ALTA'>
				<cfset ValuesArray=ArrayNew(1)>
				<cfset ArrayAppend(ValuesArray,rsClasificacion.ACcodigoCat)>
				<cfset ArrayAppend(ValuesArray,rsClasificacion.ACcodigodescCat)>
				<cfset ArrayAppend(ValuesArray,rsClasificacion.ACdescripcionCat)>	
			<cfelse>
				<cfset ValuesArray=ArrayNew(1)>
			</cfif>
							
				<cf_conlis
					Campos="ACcodigo, ACcodigodesc, ACdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					ValuesArray="#ValuesArray#"
					Title="Lista de Categorías"
					Tabla="ACategoria a"
					Columnas="ACcodigo, 
							  ACcodigodesc, 
							  ACdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo# 
					order by ACcodigodesc, ACdescripcion"
					Desplegar="ACcodigodesc, ACdescripcion"
					Etiquetas="Código,Descripción"
					filtrar_por="ACcodigodesc, ACdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="ACcodigo, ACcodigodesc, ACdescripcion"
					Asignarformatos="I,S,S,S"
					tabindex="2" />
				</div>
				<div id="Clasificacion" style="display: <cfif modo NEQ 'ALTA' and rsClasificacion.AClaId NEQ ''>''<cfelse>none</cfif> ;" >
			<cfif modo eq 'ALTA'>
				<cfset ValuesArray=ArrayNew(1)>
			<cfelse>
					<cfset ValuesArray=ArrayNew(1)>
					<cfset ArrayAppend(ValuesArray,rsClasificacion.AClaId)>
					<cfset ArrayAppend(ValuesArray,rsClasificacion.ACcodigodesc)>
					<cfset ArrayAppend(ValuesArray,rsClasificacion.ACdescripcion)>
			</cfif>
			
					<cf_conlis
						Campos="AClaId, ACcodigodescClas, ACdescripcionClas"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,40"
						ValuesArray="#ValuesArray#"
						Title="Lista de Clases"
						Tabla="AClasificacion a"
						Columnas="AClaId, ACcodigodesc as ACcodigodescClas, ACdescripcion as ACdescripcionClas, ACdescripcion as GATdescripcion"
						Filtro="Ecodigo = #Session.Ecodigo# 
						and ACcodigo = $ACcodigo,numeric$ 
						order by ACcodigodescClas, ACdescripcionClas"
						Desplegar="ACcodigodescClas, ACdescripcionClas"
						Etiquetas="Código,Descripción"
						filtrar_por="ACcodigodesc, ACdescripcion"
						Formatos="S,S"
						Align="left,left"
						Asignar="AClaId, ACcodigodescClas,ACdescripcionClas,GATdescripcion"
						Asignarformatos="I,S,S,S"
						debug="false"
						left="250"
						top="150"
						width="500"
						height="300"
						tabindex="2" />
				</div>	
			</td>
		</tr>
        <tr>
			<td align="right">
				<div id="ConceptoServicioLabel" style="display: <cfif modo NEQ 'ALTA' and isdefined("rsConceptoServicio") and rsConceptoServicio.Cid NEQ ''>''<cfelse>none</cfif>;"><strong><label>Concepto Servicio:</label></strong></div>
            </td>
			<td>				
                <div id="ConceptoServicioConlis" style="display: <cfif modo NEQ 'ALTA' and isdefined("rsConceptoServicio") and rsConceptoServicio.Cid NEQ ''>''<cfelse>none</cfif> ;" >
                <cfif modo neq 'ALTA' and isdefined("rsConceptoServicio") and rsConceptoServicio.Cid neq ''>
                    <cfset ValuesArrayC=ArrayNew(1)>
                    <cfset ArrayAppend(ValuesArrayC,rsConceptoServicio.Cid)>
                    <cfset ArrayAppend(ValuesArrayC,rsConceptoServicio.Ccodigo)>
                    <cfset ArrayAppend(ValuesArrayC,rsConceptoServicio.Cdescripcion)>	
                <cfelse>
                    <cfset ValuesArrayC=ArrayNew(1)>
                </cfif>
                                
                    <cf_conlis
                        Campos="Cid_C,Ccodigo_C,Cdescripcion_C"
                        Desplegables="N,S,S"
                        Modificables="N,S,N"
                        Size="0,10,40"
                        ValuesArray="#ValuesArrayC#"
                        Title="Lista de Conceptos de Servicios"
                        Tabla="Conceptos"
                        Columnas="Cid as Cid_C,
                        		  Ccodigo as Ccodigo_C, 
                                  Cdescripcion as Cdescripcion_C"
                        Filtro="Ecodigo = #Session.Ecodigo# order by Ccodigo, Cdescripcion"
                        Desplegar="Ccodigo_C, Cdescripcion_C"
                        Etiquetas="Código,Descripción"
                        filtrar_por="Ccodigo,Cdescripcion"
                        Formatos="S,S"
                        Align="left,left"
                        Asignar="Cid_C,Ccodigo_C,Cdescripcion_C"
                        Asignarformatos="I,S,S"
                        tabindex="3"/>
				</div>
			</td>
		</tr>
		
		<tr><td colspan="2" >&nbsp;</td></tr>
		<tr align="center">
			<td colspan="2" >
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar"  >
					<input type="reset" name="Limpiar" value="Limpiar" >
				<cfelse>	
					<input type="submit" name="Nuevo" value="Nuevo" >			
				</cfif>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
    	
		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsClasificacion.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">			
    	</cfif>
	</form>
</table>
<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<cfif modo NEQ 'ALTA' or isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
			<tr><td colspan="2" align="center"><strong>Lista de Clasificaciones</strong></td></tr>
			<tr id="Lista">
				<td colspan="2">
                	<cf_dbfunction name="OP_concat" returnvariable="_Cat">
					<cfquery name="rsLista" datasource="#session.DSN#">							
						select  b.SNnumero, b.SNnombre, 
								case 
                                when 
                                	a.CCid IS null 
                                    and a.AClaId IS null 
                                then 'Tipo: Artículos'
								when 
                                	a.CCid IS null 
                                    and a.Ccodigo IS null 
                                then 'Tipo:Activo'
								else 
                                	'Tipo: Servicios' 
                                end as tipo,
										
								case when a.CCid IS null and a.AClaId IS null then c.Cdescripcion
									  when a.CCid IS null and a.Ccodigo IS null then cl.ACdescripcion
										else  d.CCdescripcion #_Cat# ' /Concepto: ' #_Cat# coalesce(con.Ccodigo #_Cat# con.Cdescripcion, 'N/A') end as descripcion ,
										
								case when a.CCid IS null and a.AClaId IS null then c.Ccodigoclas
									  when a.CCid IS null and a.Ccodigo IS null then cl.ACcodigodesc
										else  d.CCcodigo end as codigo,
										
								a.SNcodigo,a.id,a.CCid, a.Ccodigo,a.AClaId,
								c.Cdescripcion,
								d.CCdescripcion,
								a.nivel,																
								'<img border=''0'' onClick=''eliminar();'' src=''/cfmx/sif/imagenes/Borrar01_S.gif''>' as borrar	
						from ClasificacionItemsProv a
							inner join SNegocios b
								on a.SNcodigo = b.SNcodigo
								and a.Ecodigo = b.Ecodigo
							left outer join Clasificaciones c
								on c.Ccodigo = a.Ccodigo
								and c.Ecodigo = a.Ecodigo
							left outer join CConceptos d
								on a.CCid = d.CCid
								and a.Ecodigo = d.Ecodigo
                            left join Conceptos con
                            	on con.Cid = a.Cid
							left outer join AClasificacion cl
								on cl.AClaId = a.AClaId 
						where a.Ecodigo =<cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
							and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
						order by tipo
					</cfquery>

					<cfinvoke
					 	component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rsLista#"/> 
						<cfinvokeargument name="desplegar" value="codigo,descripcion, borrar"/> 
						<cfinvokeargument name="etiquetas" value="Código,Descripción Clasificación,&nbsp;"/> 
						<cfinvokeargument name="formatos" value="S,S,S"/> 
						<cfinvokeargument name="align" value="left,left,right"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="ClasificacionSocioNeg.cfm?SNcodigo=#form.SNcodigo#"/>
						<cfinvokeargument name="keys" value="id"/> 
						<cfinvokeargument name="showEmptyListMsg" value="true"/>						
						<cfinvokeargument name="cortes" value="tipo"/>
						<cfinvokeargument name="maxrows" value="30"/>
						<cfinvokeargument name="PageIndex" value="2"/>
						<cfinvokeargument name="usaAjax" value="true"/>
						<cfinvokeargument name="conexion" value="#session.dsn#"/>
				 </cfinvoke>
				</td>
			</tr>
		</cfif>	 
</table>	
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");	
	
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description="Socio de negocio";				
	
	function deshabilitarValidacion(){
		objForm.SNcodigo.required = false;
	}
		
	//Funcion para validar que se haya seleccionado articulos o servicios
	function FuncValidar(){
		if((! document.form1.tipo[0].checked) && (! document.form1.tipo[1].checked) && (! document.form1.tipo[2].checked)){
			alert("Debe seleccionar un tipo de clasificación");
			return false;
		}
		else{
			if (document.form1.tipo[0].checked){
				
				if (document.form1.Ccodigoclas.value == ''){
					alert("Debe seleccionar una clasificación de Artículos");
					return false;
				}
			}
			else{
				if (document.form1.tipo[1].checked){
					if (document.form1.ACcodigoCat.value == ''){
						alert("Debe seleccionar una clasificación de Servicios");
						return false;
					}
				}
				
else{
			if (document.form1.tipo[2].checked){
				
				if (document.form1.ACcodigo.value == ''){
					alert("Debe seleccionar una clasificación de Activo");
					return false;
				}
			}				
			 }	
				
				
			}	
		}	
	}
	
	function FuncClasificacion(){
		var _Servicios = document.getElementById("Servicios");
		var _Articulos = document.getElementById("Articulos");
		var _Activos1 = document.getElementById("Clasificacion");
		var _Activos2 = document.getElementById("Categoria");
		var _Clasi = document.getElementById("Clas1");
		var _Cate = document.getElementById("Cat");
		var _Clas = document.getElementById("Clas");

		var _ConceptoLabel  = document.getElementById("ConceptoServicioLabel");
		var _ConceptoConlis = document.getElementById("ConceptoServicioConlis");
		
		


		if(document.form1.tipo[0].checked){
			_Servicios.style.display = 'none';
			_Clas.style.display = '';
			_Cate.style.display = 'none';
			_Clasi.style.display = 'none';
			_Articulos.style.display = '';
			_Activos1.style.display = 'none';
			_Activos2.style.display = 'none';
			_ConceptoLabel.style.display = 'none';
			_ConceptoConlis.style.display = 'none';
		}
		else 
			if(document.form1.tipo[1].checked){
				_Servicios.style.display = '';
				_Clas.style.display = '';
				_Articulos.style.display = 'none';
				_Activos1.style.display = 'none';
				_Activos2.style.display = 'none';
				_Cate.style.display = 'none';
				_Clasi.style.display = 'none';
				_ConceptoLabel.style.display = '';
				_ConceptoConlis.style.display = '';
				}
					
			else{
				_Servicios.style.display = 'none';
				_Articulos.style.display = 'none';
				_Clas.style.display = 'none';
				_Activos1.style.display = '';
				_Activos2.style.display = '';
				_Cate.style.display = '';
				_Clasi.style.display = '';
				_ConceptoLabel.style.display = 'none';
				_ConceptoConlis.style.display = 'none';
			}
	}
	
	function eliminar(){
		if (!confirm ('¿Esta seguro que desea eliminar la clasificación y lo contenido en ella?'))
			return false;					
			document.lista.action = 'SQLClasificacionSocioNeg.cfm';
			document.lista.submit;			
	}
	
	function funcSNnumero(){
		document.getElementById("Lista").style.display = 'none';
	}
</script>