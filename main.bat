@ECHO OFF
::Generate untested pack, which includes every mod in mods/ folder
chcp 65001 >NUL
ECHO.
ECHO ####################################################
ECHO #                                                  #
ECHO #        Now try to generate untested pack!        #
ECHO #                                                  #
ECHO ####################################################
ECHO.

powershell -ExecutionPolicy Bypass -NoProfile -File "./process.ps1" %*

packwiz.exe refresh
packwiz.exe modrinth export

setlocal enabledelayedexpansion
for %%f in (*.mrpack) do (
  set "filename=%%f"
  
  :: 提取文件的基本名称（不包括扩展名）
  for /f "delims=" %%i in ('echo %%~nf') do set "basename=%%i"
  
  :: 构造新的文件名
  set "newname=!basename!-%COMMIT_ID%-UNTESTED.mrpack"
  
  :: 重命名文件
  ren "%%f" "!newname!"
)
endlocal

ECHO.
ECHO ####################################################
ECHO #                                                  #
ECHO #  Untested pack generated, ready for testing!    #
ECHO #                                                  #
ECHO ####################################################
ECHO.

::Go to tested pack generation process

ECHO.
ECHO ####################################################
ECHO #                                                  #
ECHO #       Now try to generate compatible pack!       #
ECHO #                                                  #
ECHO ####################################################
ECHO.
call incompatible.bat

ECHO.
ECHO ####################################################
ECHO #                                                  #
ECHO #          Pack generated, ready for use!          #
ECHO #                                                  #
ECHO ####################################################
ECHO.
