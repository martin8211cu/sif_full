<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<link rel="stylesheet" href="../../css/asp.css" type="text/css">
<cf_sifHTML2Word Titulo="Artículos">
	<style type="text/css">
		.negativo {color:#FF0000;}
		.articulo {color:#000000; }
		.encabReporte {
			background-color: #006699;
			font-weight: bold;
			color: #FFFFFF;
			padding-top: 10px;
			padding-bottom: 10px;
		}
		.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
			border-top-color: #CCCCCC;
		}
		.bottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
			border-bottom-color: #CCCCCC;
		}
		.subTituloRep {
			font-weight: bold; 
			font-size: x-small; 
			background-color: #F5F5F5;
		}
		
		.tituloListas{ 
			color:#FFFFFF;   
			background-color:#006699;
		}
			
		.subTituloRep {
			font-weight: bold; 
			font-size: x-small; 
			background-color: #F5F5F5;
		}
	}
	</style>
	<cfif isdefined("url.ckPend")>
		<cfset form.ckPend = url.ckPend>
	</cfif>

	<form name="form1" method="post">
	<table width="80%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
		<tr> 
		  <td colspan="10"  align="center"  bgcolor="#EFEFEF"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
		</tr>
		<tr> 
		  <td colspan="10">&nbsp;</td>
		</tr>
		<tr> 
		  <td colspan="10" align="center"><font size="3"><b><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Costos de Producci&oacute;n</strong></b></font></td>
		</tr>
		<tr> 
		  <td colspan="10">&nbsp;</td>
		</tr>		
	<cfif isdefined('Url.ETid') and ltrim(rtrim(Url.ETid)) NEQ 0 and not isdefined("form.ETid")>
		<cfset form.ETid = Url.ETid>
	</cfif>
	
	<cfquery name="rsTransProds" datasource="#session.DSN#">
		Select 
			tp.Aid,
			Adescripcion,
			a.Acodigo,
			Alm_Aid, 
			Bdescripcion,
			cant, 
			costolin, 
			coalesce(costou,0) AS costou, 
			coalesce(costototal,0) AS costototal
		from TransformacionProducto tp
			inner join Almacen al
				on tp.Alm_Aid=al.Aid
					and tp.Ecodigo=al.Ecodigo
			inner join Articulos a
				on tp.Aid=a.Aid
					and tp.Ecodigo=a.Ecodigo
		where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ETid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
			and TipoLinea= 30
		order by Alm_Aid,tp.Aid
	</cfquery>	
	
	<cfif isdefined('rsTransProds') and rsTransProds.recordCount GT 0>	
		<table width="100%" cellpadding="0" cellspacing="0"  border="0">
		  <tr class="tituloListas">
			<td width="9%"><div align="center" class="label">Almac&eacute;n</div></td>
			<td width="9%"><div align="left" class="label">Articulo</div></td>
			<td width="42%"><div align="center" class="label"></div></td>
			<td width="11%"><div align="right" class="label">Cantidad</div></td>
			<td width="13%"><div align="right" class="label">Costo Producci&oacute;n </div></td>
			<td width="16%"><div align="right" class="label">Costo Unitario</div></td>
		  </tr>
		  <cfset vAlmacen = "">
		  <cfset vArticulo = "">  
		  <cfoutput>
			  <cfloop query="rsTransProds">
					<cfif rsTransProds.Alm_Aid NEQ vAlmacen >
						<cfset vAlmacen = rsTransProds.Alm_Aid>
						<tr>
							<td colspan="6"><strong>#rsTransProds.Bdescripcion#</strong></td>
						</tr>
					</cfif>
					<cfif rsTransProds.Aid NEQ vArticulo >
						<cfset vArticulo = rsTransProds.Aid>					
						<cfset LvarListaNon = (CurrentRow MOD 2)>						
					  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
						<td width="9%">&nbsp;</td>
						<td colspan="2"><strong>#rsTransProds.Acodigo# - </strong>#rsTransProds.Adescripcion#</td>
						<td width="11%" align="right">#LSNumberFormat(rsTransProds.cant,"-__________.__")#</td>
						<td width="13%" align="right">#LSNumberFormat(rsTransProds.costototal,"-__________.__")#</td>
						<td width="16%" align="right">#LSNumberFormat(rsTransProds.costou,"-__________.__")#</td>
					  </tr>				
					</cfif>
			  </cfloop>
			</cfoutput>			  
		</table>
	</cfif>
	
	
	<input name="ETid" type="hidden" value="#form.ETid#">		
</form>
</cf_sifHTML2Word>