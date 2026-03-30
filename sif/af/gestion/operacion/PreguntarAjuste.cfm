<title>
Asientos de Ajuste
</title>	
<cf_templatecss>
<cf_web_portlet_start titulo="Asientos de Ajuste">

	<cf_dbtemp name="CSCAJUSTES" returnvariable="CSCAJUSTES" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"    	type="int"      	mandatory="yes">
		<cf_dbtempcol name="GATperiodo"    	type="int"      	mandatory="yes">
		<cf_dbtempcol name="GATmes"    		type="int"      	mandatory="yes">
		<cf_dbtempcol name="Cconcepto"    	type="int"          mandatory="yes">
		<cf_dbtempcol name="Edocumento"    	type="int"     		mandatory="yes">
		<cf_dbtempcol name="GATestado"    	type="int"  		mandatory="yes">
		<cf_dbtempcol name="Cdescripcion"   type="varchar(50)"  mandatory="yes">
		<cf_dbtempcol name="Mes"    		type="varchar(10)"  mandatory="yes">
		<cf_dbtempcol name="Ajustar"    	type="int"  		mandatory="yes">				
	</cf_dbtemp>

	<br><br>
	<strong>Los siguientes consecutivos deben generar un asiento de ajuste:</strong>
	<br><br>
	
	<cfloop list="#URL.chk#" index="llave">
		<cfscript>
			arr_llave = ListToArray(llave,'|');
			item = StructNew();
			StructInsert(item, "Periodo", arr_llave[1]);
			StructInsert(item, "Mes", arr_llave[2]);
			StructInsert(item, "Concepto", arr_llave[3]);
			StructInsert(item, "Documento", arr_llave[4]);
		</cfscript>
		
		<cfquery name="rsTieneAjustes" datasource="#session.dsn#">
			Select count(1) as ajustarCSC
			from GATransacciones a						
			where a.OcodigoAnt is not null
			  and a.Ocodigo != a.OcodigoAnt
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Periodo#">
			  and a.GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Mes#">
			  and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Concepto#">
			  and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Documento#">	
		</cfquery>
		
		<cfif rsTieneAjustes.ajustarCSC gt 0>
		
			<cfquery name="rsAstAjustes" datasource="#session.dsn#">
				INSERT into #CSCAJUSTES#(Ecodigo, GATperiodo, GATmes, Cconcepto, Edocumento, GATestado, Cdescripcion,Mes,Ajustar)
				Select distinct #session.Ecodigo#, a.GATperiodo, a.GATmes, a.Cconcepto, a.Edocumento, a.GATestado, b.Cdescripcion,
				(coalesce(( select min(VSdesc)
							from VSidioma vs
							where Iid = (select min(Iid) 
										 from Idiomas id 
										 where id.Icodigo = '#SESSION.IDIOMA#')
							  and VSgrupo = 1
							  and <cf_dbfunction name="to_number" args="VSvalor"> = a.GATmes),convert(varchar,a.GATmes))) as Mes, 1
							  
				from GATransacciones a
						inner join ConceptoContableE b
							 on b.Ecodigo = a.Ecodigo
							and b.Cconcepto = a.Cconcepto
							
				where a.OcodigoAnt is not null
				  and a.Ocodigo != a.OcodigoAnt
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				  and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Periodo#">
				  and a.GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Mes#">
				  and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Concepto#">
				  and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Documento#">	
			</cfquery>
		
		<cfelse>
		
			<cfquery name="rsAstAjustes" datasource="#session.dsn#">
				INSERT into #CSCAJUSTES#(Ecodigo, GATperiodo, GATmes, Cconcepto, Edocumento, GATestado, Cdescripcion,Mes,Ajustar)
				Select distinct #session.Ecodigo#, a.GATperiodo, a.GATmes, a.Cconcepto, a.Edocumento, a.GATestado, b.Cdescripcion,
				(coalesce(( select min(VSdesc)
							from VSidioma vs
							where Iid = (select min(Iid) 
										 from Idiomas id 
										 where id.Icodigo = '#SESSION.IDIOMA#')
							  and VSgrupo = 1
							  and <cf_dbfunction name="to_number" args="VSvalor"> = a.GATmes),convert(varchar,a.GATmes))) as Mes, 0
							  
				from GATransacciones a
						inner join ConceptoContableE b
							 on b.Ecodigo = a.Ecodigo
							and b.Cconcepto = a.Cconcepto
							
				where (a.OcodigoAnt is null or a.Ocodigo = a.OcodigoAnt)
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				  and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Periodo#">
				  and a.GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Mes#">
				  and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Concepto#">
				  and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Documento#">	
			</cfquery>	
		
		</cfif>	
						
	</cfloop>

	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		columnas="  a.GATperiodo, 
					a.GATmes, 
					a.Cconcepto, 
					a.Edocumento, 
					a.GATestado as Estado, 
					a.Cdescripcion,
					a.Mes"
		tabla="#CSCAJUSTES#	a"
		filtro=" a.Ecodigo = #SESSION.ECODIGO#						
					and Ajustar=1
					order by a.GATperiodo, a.GATmes, a.Cdescripcion, a.Edocumento"	
		desplegar="GATperiodo, Mes, Cdescripcion, Edocumento, Estado"
		etiquetas="Periodo, Mes, Concepto, Documento, Estado"
		formatos="I, I, I, I, I"
		align="left, left, left, left, left"
		irA="Conciliacion.cfm"
		keys="GATperiodo, GATmes, Cconcepto, Edocumento"
		checkboxes="S"
		showLink="false"
		botones=""
		mostrar_filtro="false"
		filtrar_automatico="false"
		debug="N"
	/>		
	
	<cfquery datasource="#session.dsn#" name="rev">
	<cf_dbfunction name="OP_concat" returnvariable="_Cat">
	Select distinct (
	                 rtrim(ltrim(<cf_dbfunction name="to_char"	args="GATperiodo">)) #_Cat# '|' #_Cat#   
					 rtrim(ltrim(<cf_dbfunction name="to_char"	args="GATmes">))     #_Cat# '|' #_Cat#   
					 rtrim(ltrim(<cf_dbfunction name="to_char"	args="Cconcepto">))  #_Cat# '|' #_Cat#  
					 rtrim(ltrim(<cf_dbfunction name="to_char"	args="Edocumento">))
					 ) as valor
	from #CSCAJUSTES#
	where Ajustar=0
	  and Ecodigo = #session.ecodigo#	
	</cfquery>
	

	<cfif rev.recordcount gt 0>
	
		<br><br>
		<strong>Consecutivos adicionales que se van a aplicar y no requieren de ajuste:</strong>
		<br><br>	
		
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			columnas="  a.GATperiodo, 
						a.GATmes, 
						a.Cconcepto, 
						a.Edocumento, 
						a.GATestado as Estado, 
						a.Cdescripcion,
						a.Mes"
			tabla="#CSCAJUSTES#	a"
			filtro=" a.Ecodigo = #SESSION.ECODIGO#						
						and Ajustar=0
						order by a.GATperiodo, a.GATmes, a.Cdescripcion, a.Edocumento"	
			desplegar="GATperiodo, Mes, Cdescripcion, Edocumento, Estado"
			etiquetas="Periodo, Mes, Concepto, Documento, Estado"
			formatos="I, I, I, I, I"
			align="left, left, left, left, left"
			keys="GATperiodo, GATmes, Cconcepto, Edocumento"
			checkboxes="N"
			botones=""
			formName="form1"
			showLink="false"
			mostrar_filtro="false"
			filtrar_automatico="false"
			debug="N"
		/>			
	
	</cfif>
	
	<br>
	<form name="frmapl" action="PreguntarAjuste-sql.cfm" method="post">
	<cfoutput>
	<input type="hidden" name="GATPERIODO" value="#url.GATPERIODO#">
	<input type="hidden" name="GATMES" value="#url.GATMES#">
	<input type="hidden" name="FIELDNAMES" value="#url.FIELDNAMES#">
	<input type="hidden" name="EDOCUMENTO" value="#url.EDOCUMENTO#">
	<input type="hidden" name="CHK" value="#url.CHK#">
	<input type="hidden" name="CCONCEPTO" value="#url.CCONCEPTO#">
	<input type="hidden" name="BTNAPLICAR" value="#url.BTNAPLICAR#">
	<input type="hidden" name="BOTONSEL" value="#url.BOTONSEL#">	
	<input type="hidden" name="CHKsel" value="">
	<cfset V_chk = "">
	<cfloop query="rev">
		<cfif V_chk eq "">	
			<cfset V_chk = rev.valor>
		<cfelse>
			<cfset V_chk = V_chk & "," & rev.valor>
		</cfif>
	</cfloop>
	<input type="hidden" name="CHKbase" value="#V_chk#">
	</cfoutput>	
	<center>
	<input type="submit" name="btnAplicar" class="btnGuardar" value="Aplicar y Generar Ajuste" onclick="javascript: if (window.funcAplicar) return funcAplicar();" tabindex="0">
	<input type="button" name="btncerrar" class="btnNormal" value="Cancelar" onClick="javascript:window.close()">
	</center>
	</form>	
	<script>
	function funcAplicar(){
		
		//verifica si hay algo marcado
		field = document.lista.chk
		apl = false;

		if (field.length > 0)
		{			
			for (i = 0; i < field.length; i++) 
			{
				if (field[i].checked)
				{
					if (document.frmapl.CHKsel.value == '')
						document.frmapl.CHKsel.value = field.value;
					else
						document.frmapl.CHKsel.value = document.frmapl.CHKsel.value + ',' + field.value;
					apl = true;
				} 
			}
		}
		else
		{
			if (field.checked)
			{
				document.frmapl.CHKsel.value = field.value;
				apl = true;
			}
		}
		if (apl)
		{
			return confirm("¿Desea aplicar el movimiento?");	
		}
		else
		{	
			alert("Debe seleccionar al menos un consecutivo")
			return false;
		}
	}
	</script>
	
<cf_web_portlet_end>