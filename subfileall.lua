local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

local function dirtree(dir)
  assert(dir and dir ~= "", "Please pass directory parameter.")

  local files = {}
  
  for entry in lfs.dir(dir) do
    if not lfs.isdir(entry) and ends_with(entry, ".tex") then
      table.insert(files, entry)
    end
  end

  table.sort(files)
  return files
end

local files = dirtree(lfs.currentdir() .. "/songs")
for i = 1, #files do
  tex.print("\\subfile{songs/" .. files[i] .. "}")
end
