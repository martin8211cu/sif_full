<cf_navegacion name="autores"	default="">
<cf_navegacion name="IDsch"		default="">
<cf_navegacion name="IDmod"		default="">
<cfif isdefined("url.OP") and  isdefined("url.IDver")>
	<cfif url.OP EQ "ADD">
		<cfquery datasource="asp">
			update DBMversiones
			   set parche = '#session.parche.guid#'
			 where IDver = #url.IDver#
		</cfquery>
	<cfelseif url.OP EQ "DEL">
		<cfquery datasource="asp">
			update DBMversiones
			   set parche = NULL
			 where IDver = #url.IDver#
		</cfquery>
	</cfif>
	<cfinvoke component="asp.parches.comp.parche" method="contar" />
	<cflocation url="dbmbuscar.cfm?x=#getTickCount()#&autores=#urlEncodedFormat(form.autores)#&IDsch=#urlEncodedFormat(form.IDsch)#&IDmod=#urlEncodedFormat(form.IDmod)#">
</cfif>
<cf_templateheader title="Creación de Parches">
	<cfinclude template="mapa.cfm">
	<h1>Seleccionar Versiones de DBM DataBaseModel</h1>
	<p>
	Seleccione el schema, modelo .pdm, fecha y usuario de las versiones que no han sido incluidas en parche.</p>
	<p>Marque las versiones que desea incluir en el parche.  </p>

	<cfif form.autores EQ "">
		<cfset form.autores="#session.parche.svnuser#"> 
	</cfif>
	<cfif form.autores EQ "">
		<cfset form.autores="(SVN User)"> 
	</cfif>
	
	<cfquery datasource="asp" name="rsSch">
		select IDsch, sch
		  from DBMsch
		order by IDsch
	</cfquery>

	<cfquery datasource="asp" name="rsSQL">
		select m.IDsch
		  from APParche p
			join APEsquema e
				on e.esquema = p.pdir
			left join DBMmodelos m
				on m.IDmod = e.IDmod
		where parche = '#session.parche.guid#'
	</cfquery>
	<cfif form.IDsch EQ "">
		<cfset form.IDsch = rsSQL.IDsch>
	</cfif>

	<cfquery datasource="asp" name="rsMod">
		select m.IDsch, m.IDmod, m.modelo as des
		  from DBMmodelos m
		 order by m.modelo
	</cfquery>
<script language="javascript">
	var GvarMods = Array();
<cfoutput query="rsMod">
	var LvarMod = Option
	GvarMods[#rsMod.currentRow-1#] = new Object;
	GvarMods[#rsMod.currentRow-1#]["sch"] = "#rsMod.IDsch#";
	GvarMods[#rsMod.currentRow-1#]["opt"] = new Option ("#JSStringFormat(des)#","#IDmod#");
</cfoutput>
	function sbChangeSch(IDsch)
	{
		var cboMod = document.getElementById("IDmod");
		var cboI = 0;
		cboMod.options.length = 0;
		cboMod.options[0] = new Option ("Todos los modelos","");;
		for (var i=0;i<<cfoutput>#rsMod.recordCount#</cfoutput>;i++)
		{
			if ((IDsch == '') || (IDsch == GvarMods[i]["sch"]))
			{
				cboI ++;
				cboMod.options[cboI] = GvarMods[i]["opt"];
			}
		}
	}
	function sbOP(IDver,chk)
	{
		//alert ("dbmbuscar.cfm?IDver=" + IDver + "&OP=" + (chk?'ADD':'DEL'));
		<cfoutput>
		location.href="dbmbuscar.cfm?IDver=" + IDver + "&OP=" + (chk?'ADD':'DEL') + "&autores=#urlEncodedFormat(form.autores)#"  + "&IDsch=#urlEncodedFormat(form.IDsch)#"  + "&IDmod=#urlEncodedFormat(form.IDmod)#";
		</cfoutput>
	}
</script>

	<form height="300" width="700" id="form1" name="form1" 
		method="post" action="dbmbuscar.cfm" format="#session.parche.form_format#"
		timeout="60">

		<cf_web_portlet_start width="700" titulo="Versiones de Data Base Model">
				<table>
					<cfif isdefined("form.mensaje") and len(trim(form.mensaje))>
						<cfoutput><tr><td colspan="2" align="center" style="color:##FF0000 ">***** #XMLFormat(form.mensaje)# *****</td></tr></cfoutput>
					</cfif>
					<tr>						
						<td><label for="IDsch">Schema</label></td>												
						<td>
							<select name="IDsch" label="Schema" width="350" style="width:350px" onChange="javascript: sbChangeSch(this.value);">
								<option value="%">Todos los schemas</option>
								<cfoutput query="rsSch">
									<option value="#IDsch#"<cfif form.IDsch EQ IDsch> selected</cfif>>#sch#</option>
								</cfoutput> 
							</select>
						</td>						
					</tr>
					<tr>
						<td><label for="IDmod">Modelo .pdm</label></td>
						<td>
							<select name="IDmod" id="IDmod" label="Modelo" width="350" style="width:350px">									
								<option value="%">Todos los modelos</option>
								<cfoutput query="rsMod">
									<cfif form.IDsch EQ "" or form.IDsch EQ rsMod.IDsch>
										<option value="#IDmod#"<cfif form.IDmod EQ IDmod> selected</cfif>>#des#</option>
									</cfif>
								</cfoutput> 
							</select>
						</td>
					</tr>
					<tr>
						<td><label for="autores">Autor(es):</label></td>
						<td>
							<input name="autores" id="autores" value="<cfoutput>#form.autores#</cfoutput>" style="width:350px"/>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<table>
								<tr>
									<td>
										<!---<cfinput type="submit" name="Submit" value="Agregar" class="btnGuardar" />--->
										<input type="submit" name="Buscar" value="Buscar" class="button" >
									</td>
									<td><input name="continuar" type="button" id="continuar" value="Continuar" class="btnSiguiente" onClick="javascript: location.href = 'menubuscar-a.cfm'"/></td>
								</tr>
							</table>
						</td>
					</tr>	
				</table>
				<cfset fnDetalle('#session.parche.guid#')>
		<cf_web_portlet_end>
	</form>
<cf_templatefooter>
<iframe name="ifrVer" id="ifrVer" width="0" height="0" frameborder="0"> 
</iframe>

<cffunction name="fnDetalle" output="true">
	<cfargument name="parche"	required="yes">

	<cf_dbfunction name="OP_Concat" returnvariable="CAT" datasource="asp">
	<cfquery name="rsDetalle" datasource="asp">
		select 	'<input type="checkbox" onclick="sbOP(' #CAT# 
				<cf_dbfunction name="to_char" args="v.IDver"> #CAT# 
				',this.checked);"' #CAT# 
				case when v.parche is not null then ' checked' else '' end #CAT#
				'>' as chk, 
				s.sch #CAT# ' / ' #CAT# 
				m.modelo #CAT# ':<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
				#CAT# des as version, 
				fec, v.uidSVN, IDver
		  from DBMversiones v
			inner join DBMmodelos m on m.IDmod=v.IDmod
			inner join DBMsch s	on s.IDsch=m.IDsch
		where v.parche = '#arguments.parche#'
		   OR (
		<cfif form.autores NEQ "%">
				v.uidSVN in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#form.autores#">)
				and
		</cfif>
				v.parche is null
		<cfif form.IDsch NEQ "" AND form.IDsch NEQ "%">
			and s.IDsch = #form.IDsch#
		</cfif>
		<cfif form.IDmod NEQ "" AND form.IDmod NEQ "%">
			and v.IDmod = #form.IDmod#
		</cfif>
			)
		order by IDver
	</cfquery>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#rsDetalle#"
		desplegar="chk, version, fec, uidSVN, IDver"
		etiquetas="OP, SCHEMA / MODULO: VERSION, FECHA, USUARIO, VERSION"
		formatos="S,S,DT,S,S"
		align="center,left,left,center,right"
		ajustar="S,N,N,N"
		form_method="post"
		showEmptyListMsg="yes"
		showLink = "no"
		incluyeForm = "no"
		pageindex="1"
		checkbox="si"
		usaAJAX = "no"
		navegacion = "#navegacion#"
	/>
</cffunction>