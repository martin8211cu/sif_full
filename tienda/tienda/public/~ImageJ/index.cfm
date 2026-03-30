<cfsilent>
<!---
 @author Benoit Hediard (ben@benorama.com) 
 @version 0.9, April 22, 2003
 @description Imaging Application to test ImageJ CFC, only work locally 
--->
<cfset manipulationsList = "rotateLeft,rotateRight,flipHorizontal,flipVertical">
<cfset filtersList = "invert,findEdges,medianFilter,smooth,sharpen,erode,dilate,grayscale">
<cfparam name="form.originalImagePath" type="string" default="">
<cfloop index="action" list="#manipulationsList#,#filtersList#">
	<cfparam name="form[action]" type="boolean" default="false">
</cfloop>
<cfparam name="form.gammaMore" type="boolean" default="false">
<cfparam name="form.gammaLess" type="boolean" default="false">
<cfparam name="form.drawLine" type="boolean" default="false">
<cfparam name="form.drawLineColor" type="string" default="FF0000">
<cfparam name="form.drawLineSize" type="numeric" default="1">
<cfparam name="form.drawString" type="boolean" default="false">
<cfparam name="form.drawStringColor" type="string" default="0000FF">
<cfparam name="form.drawStringBold" type="boolean" default="false">
<cfparam name="form.drawStringItalic" type="boolean" default="false">
<cfparam name="form.drawStringAntialiased" type="boolean" default="false">
<cfparam name="form.drawStringSize" type="numeric" default="12">
<cfparam name="form.drawStringText" type="string" default="Hello from ImageJ!">
<cfparam name="form.drawStringFont" type="string" default="SansSerif">
<cfparam name="form.resize" type="boolean" default="false">
<cfparam name="form.resizeValue" type="numeric" default="200">
<cfparam name="form.crop" type="boolean" default="false">
<cfparam name="form.cropValue" type="numeric" default="200">
<cfparam name="form.scale" type="boolean" default="false">
<cfparam name="form.scaleValue" type="numeric" default="2">
<cfparam name="form.format" type="string" default="auto">
<cfparam name="form.jpgQuality" type="numeric" default="70">

<cfif len(form.originalImagePath)>
	<cfscript>
	image = createObject("component","ImageJ");
	image.open(form.originalImagePath);
	form.originalType = image.getType();
	form.originalWidth = image.getWidth();
	form.originalHeight = image.getHeight();
	</cfscript>
	<cfset doDisplayImage = true>
<cfelse>
	<cfset doDisplayImage = false>
</cfif>
<cfif structKeyExists(form,"actionSubmit")>
	<cfif form.format is "auto">
		<cfset form.resultImagePath = getTempDirectory() & "imageJ." & listLast(form.originalImagePath,".")>
	<cfelse>
		<cfset form.resultImagePath = getTempDirectory() & "imageJ." & form.format>
	</cfif>
	<cfloop index="action" list="#filtersList#">
		<cfif form[action]>
			<cfswitch expression="#action#">
			<cfcase value="invert"><cfset image.invert()></cfcase>
			<cfcase value="medianFilter"><cfset image.medianFilter()></cfcase>
			<cfcase value="smooth"><cfset image.smooth()></cfcase>
			<cfcase value="sharpen"><cfset image.sharpen()></cfcase>
			<cfcase value="erode"><cfset image.erode()></cfcase>
			<cfcase value="dilate"><cfset image.dilate()></cfcase>
			<cfcase value="findEdges"><cfset image.findEdges()></cfcase>
			<cfcase value="grayscale"><cfset image.grayscale()></cfcase>
			</cfswitch>
		</cfif>
	</cfloop>
	<cfloop index="action" list="#manipulationsList#">
		<cfif form[action]>
			<cfswitch expression="#action#">
			<cfcase value="rotateLeft"><cfset image.rotateLeft()></cfcase>
			<cfcase value="rotateRight"><cfset image.rotateRight()></cfcase>
			<cfcase value="flipHorizontal"><cfset image.flipHorizontal()></cfcase>
			<cfcase value="flipVertical"><cfset image.flipVertical()></cfcase>
			</cfswitch>
		</cfif>
	</cfloop>
	<cfif form.gammaMore>
		<cfset image.gamma(2)>
	</cfif>
	<cfif form.gammaLess>
		<cfset image.gamma(0.5)>
	</cfif>
	<cfif form.drawLine>
		<cfset image.setColor(form.drawLineColor)>
		<cfset image.setLineWidth(form.drawLineSize)>
		<cfset image.drawLine(0,0,image.getWidth(),image.getHeight())>
		<cfset image.drawLine(image.getWidth(),0,0,image.getHeight())>
	</cfif>
	<cfif form.drawString>
		<cfset yString = 10 + form.drawStringSize>
		<cfset image.setFont(form.drawStringFont,form.drawStringSize,form.drawStringBold,form.drawStringItalic,form.drawStringAntialiased)>
		<cfset image.setColor(form.drawStringColor)>
		<cfset image.drawString(10,yString,form.drawStringText)>
	</cfif>
	<cfif form.resize>
		<cfset image.resize(form.resizeValue)>
	</cfif>
	<cfif form.crop>
		<cfset image.setROI(0,0,form.cropValue,form.cropValue)>
		<cfset image.crop(form.resizeValue)>
	</cfif>
	<cfif form.scale>
		<cfset image.scale(form.scaleValue,form.scaleValue)>
	</cfif>
	<cfswitch expression="#form.format#">
	<cfcase value="gif"><cfset image.saveAsGif(form.resultImagePath)></cfcase>
	<cfcase value="jpg"><cfset image.saveAsJpeg(form.resultImagePath,form.jpgQuality)></cfcase>
	<cfdefaultcase><cfset image.saveAs(form.resultImagePath)></cfdefaultcase>
	</cfswitch>
	<cfscript>
	form.resultType = image.getType();
	form.resultWidth = image.getWidth();
	form.resultHeight = image.getHeight();
	</cfscript>
	<cfset doDisplayResult = true>
<cfelse>
	<cfset doDisplayResult = false>
</cfif>
</cfsilent>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Imaging application (ImageJ testing)</title>
	<meta http-equiv="expires" content="Tue, 10 May 1999 15:00:00 GMT">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no cache"> 
	<meta http-equiv="content-type" content="text/html; charset=utf-8">
</head>

<body>

<cfoutput>
<table>
<form action="#cgi.SCRIPT_NAME#" method="post" name="uploadForm">
<tr>
	<td>
	<i>1. Select an image</i> : 
	</td>
	<td>
	<input name="originalImagePath" type="file" size="45"> 
	</td>
	<td>
	<input name="selectSubmit" type="submit" value="Submit">
	</td>
</tr>
</form>
</table>


<cfif doDisplayImage>
	<hr>
	<table>
	<form action="#cgi.SCRIPT_NAME#" method="post" name="actionForm">
	<tr>
		<td valign="top">
			<img src="#form.originalImagePath#" border="1">
		</td>
		<td valign="top">
			<i>2. Select an action</i> :<br>
			<br>
			<table>
			<tr>
				<td valign="top">
				<cfloop index="action" list="#filtersList#">
					<input type="checkbox" name="#action#" value="true" <cfif form[action]>checked</cfif>> #action#<br>
				</cfloop>
				</td>
				<td valign="top">
				<cfloop index="action" list="#manipulationsList#">
					<input type="checkbox" name="#action#" value="true" <cfif form[action]>checked</cfif>> #action#<br>
				</cfloop>
				</td>
			</tr>
			</table>
			
			<input type="checkbox" name="gammaMore" value="true" <cfif form.gammaMore>checked</cfif>> darker (gamma+)<br>
			<input type="checkbox" name="gammaLess" value="true" <cfif form.gammaLess>checked</cfif>> lighter (gamma-)<br>
			<br>
			<input type="checkbox" name="drawLine" value="true" <cfif form.drawLine>checked</cfif>> drawLine
			<input type="text" name="drawLineColor" value="#form.drawLineColor#" size="3" maxlength="6"> (color)
			<select name="drawLineSize"><cfloop index="i" from="1" to="5" step="1"><option value="#i#" <cfif form.drawLineSize eq i>selected</cfif>>#i#</option></cfloop></select> (size)<br>
			<br>
			<input type="checkbox" name="drawString" value="true" <cfif form.drawString>checked</cfif>> drawString
			<input type="text" name="drawStringColor" value="#form.drawStringColor#" size="3" maxlength="6"> (color)
			<select name="drawStringSize"><cfloop index="i" from="1" to="30" step="1"><option value="#i#" <cfif form.drawStringSize eq i>selected</cfif>>#i#</option></cfloop></select> (size)<br>
			&nbsp;&nbsp;&nbsp;<input type="checkbox" name="drawStringBold" value="true"  <cfif form.drawStringBold>checked</cfif>> bold 
			<input type="checkbox" name="drawStringItalic" value="true"  <cfif form.drawStringItalic>checked</cfif>> italic 
			<input type="checkbox" name="drawStringAntialiased" value="true"  <cfif form.drawStringAntialiased>checked</cfif>> antialiased<br>
			&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="drawStringText" value="#form.drawStringText#" size="15" maxlength="100"> (text)<br>
			<br>
			<input type="checkbox" name="resize" value="true" <cfif form.resize>checked</cfif>> resize
			<input type="text" name="resizeValue" value="#form.resizeValue#" size="2" maxlength="3"> pix<br>
			<input type="checkbox" name="crop" value="true" <cfif form.crop>checked</cfif>> crop
			<input type="text" name="cropValue" value="#form.cropValue#" size="2" maxlength="3"> pix<br>
			<input type="checkbox" name="scale" value="true" <cfif form.scale>checked</cfif>> scale
			<select name="scaleValue"><cfloop index="i" from="1" to="4" step="1"><option value="#i#" <cfif form.scaleValue eq i>selected</cfif>>x#i#</option></cfloop></select><br>
			<br>
			<input name="format" type="radio" value="auto" <cfif form.format is "auto">checked</cfif>> Auto |
			<input name="format" type="radio" value="gif" <cfif form.format is "gif">checked</cfif>> Gif |
			<input name="format" type="radio" value="jpg" <cfif form.format is "jpg">checked</cfif>> Jpg
			quality <select name="jpgQuality" size="1"><cfloop index="i" from="10" to="100" step="10"><option value="#i#" <cfif form.jpgQuality eq i>selected</cfif>>#i#</option></cfloop></select>
			<br>
			<br>
			<input type="hidden" name="originalImagePath" value="#form.originalImagePath#">
			<input name="actionSubmit" type="submit" value="Submit">
		</td>
	</tr>
	<tr>
		<td colspan="2">
			Type : <b>#form.originalType#</b> | 
			width : <b>#form.originalWidth#</b> |
			height : <b>#form.originalHeight#</b><br>
			Filename : <b>#form.originalImagePath#</b>
		</td>
	</tr>
	</form>
	</table>
</cfif>

<cfif doDisplayResult>
	<hr>
	<table>
	<tr>
		<td valign="top">
			<img src="#form.resultImagePath#" border="1">
		</td>
		<td valign="top">
		<i>3. See the result</i><br>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			Type : <b>#form.resultType#</b> | 
			width : <b>#form.resultWidth#</b> | 
			height : <b>#form.resultHeight#</b><br>
			Filename : <b>#form.resultImagePath#</b>	
		</td>
	</tr>
	</form>
	</table>
</cfif>

</cfoutput>

</body>
