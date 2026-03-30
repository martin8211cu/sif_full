<cfset t=createObject("component", "sif.Componentes.Translate")>   
<cfif not StructKeyExists(session, "LvarFiltroEmpresasDT")>
	<cfset session.LvarFiltroEmpresasDT = session.Ecodigo>
</cfif>

<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')/>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')/>
<cfset LB_Anno = t.translate('LB_Anno','Año','/rh/generales.xml')/>
<cfset LB_Mes = t.translate('LB_Mes','Mes','/rh/generales.xml')/>
<cfset LB_Formato = t.translate('LB_Formato','Formato','/rh/generales.xml')/>
<cfset LB_ListaDeDeduccionesAIncluir = t.translate('LB_ListaDeDeduccionesAIncluir','Lista de Deducciones a incluir')/>

<body>
<form class="bs-example form-horizontal" action="RepCambiosCreditUnion-sql.cfm" method="post" name="form1" style="margin:0">
	<cfquery datasource="#session.dsn#" name="rsMeses">
		select <cf_dbfunction name="to_number" args="vs.VSvalor"> as VSvalor, vs.VSdesc
			from VSidioma vs
			    inner join Idiomas i
			        on vs.Iid = i.Iid
			where vs.VSgrupo=1
			and i.Icodigo = '#session.idioma#'
			order by 1
	</cfquery>
	<div class="form-group">
		<label for="DCcodigo" class="col-lg-3 control-label"><cfoutput>#LB_Mes#</cfoutput>:</label>
		<div class="col-lg-2">
        	<select class="form-control" id="CPmes" name="CPmes">
        		<cfoutput query="rsMeses">
	            	<option value="#VSvalor#">#VSdesc#</option>
	        	</cfoutput>
	          </select>
        </div>
    </div>    
	<div class="form-group">
		<label for="DCcodigo" class="col-lg-3 control-label"><cfoutput>#LB_Anno#</cfoutput>:</label>
		<div class="col-lg-2">
        	<select class="form-control" id="CPperiodo" name="CPperiodo">
        	<cfloop from="#year(now())#" to="#year(now())-15#" index="i" step="-1">
        		<cfoutput><option value="#i#">#i#</option></cfoutput>
        	</cfloop>
          </select>
        </div>
	</div>
	<div class="form-group">
		<label for="TDcodigo" class="col-lg-3 control-label"><cfoutput>#LB_ListaDeDeduccionesAIncluir#</cfoutput>:</label>
		<div class="col-lg-9">
         <cf_conlis
			Campos="TDid,TDcodigo,TDdescripcion"
			Desplegables="N,S,S"
			Modificables="N,N,N"
			Size="0,15,25"
			tabindex="2" 
			Title="#LB_ListaDeDeduccionesAIncluir#"
			Tabla="TDeduccion"
			Columnas="distinct TDid,TDcodigo,TDdescripcion"
			Desplegar="TDcodigo,TDdescripcion"
			Etiquetas="#LB_Codigo#,#LB_Descripcion#"
			filtro="Ecodigo = #session.Ecodigo# order by TDdescripcion,TDcodigo"
			filtrar_por="TDcodigo,TDdescripcion"
			Formatos="S,S"
			Align="left,left"
			Asignar="TDid,TDcodigo,TDdescripcion"
			agregarEnLista="true" 
			Asignarformatos="X,S,S"
			TranslateDataCols="TDdescripcion"
			/>
        </div>
	</div>

	<div class="form-group">
		<label for="DCcodigo" class="col-lg-3 control-label"><cfoutput>#LB_Formato#</cfoutput>:</label>
		<div class="col-lg-2">
        	<select class="form-control"  name="formato">
        		<option value="html">HTML</option>
        		<option value="excel">Excel</option>
        		<option value="pdf">PDF</option>
          	</select>
        </div>
	</div>

	<div class="form-group">
		<cf_botones values="Consultar,Limpiar">
	</div>	
</form>
</body>