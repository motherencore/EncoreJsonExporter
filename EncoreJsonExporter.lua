local json = dofile("_modules/json.lua")

local spr = app.activeSprite
if not spr then return print('No active sprite') end

local path,title = spr.filename:match("^(.+[/\\])(.-).([^.]*)$")

title = title .. ".json"

local fn = spr.filename
local fpath = app.fs.filePath(fn)

local jsonData = {}
local deduplicatedFrames = {}

jsonData.size = {}
jsonData.offset = {}
jsonData.animations = {}

local function getFrameImage(frameIdx)
    local image = Image(spr.spec)
    image:drawSprite(spr, frameIdx)
    return image
end

local function getFirstEqualFrame(frameIdx)
    local img = getFrameImage(frameIdx)
    for i = 1, #spr.frames do
        local compareImg = getFrameImage(i)
        if img:isEqual(compareImg) then
            return i
        end
    end
    return frameIdx
end

local function buildFrame(frames, frameIdx)
    local frame = {}
    local idx = deduplicatedFrames[frameIdx] or frameIdx
    if #frames ~= 0 and frames[#frames][1] == idx then
        frames[#frames][2] = frames[#frames][2] + spr.frames[frameIdx].duration
    else
        table.insert(frame,idx)
        table.insert(frame,spr.frames[frameIdx].duration)
        table.insert(frames,frame)
    end
end

local pathChanged = false

local function filePathChanged()
    pathChanged = true
end

local dlg = Dialog()

-- path of the json file (where the json should be exported)
dlg:file{ id="file_path",
          title="Json Path",
          label="Json Path:",
          filename=title,
          open=false,
          save=true,
          entry=true,
          filetypes={ "json" },
          onchange=filePathChanged
}


dlg:entry{ id="hframes", label="Horizontal Frames:"}
dlg:entry{ id="vframes", label="Vertical Frames:"}


dlg:entry{ id="xoffset", label="X Offset:", text="0"}
dlg:entry{ id="yoffset", label="Y Offset:", text="0"}

dlg:check{ id="merge_duplicates", label="Merge Duplicate Frames", selected=true}

dlg:button{ id="confirm", text="Confirm" }
dlg:button{ id="cancel", text="Cancel" }
dlg:show()

table.insert(jsonData.size, tonumber(dlg.data.hframes))

table.insert(jsonData.size, tonumber(dlg.data.vframes))

table.insert(jsonData.offset, tonumber(dlg.data.xoffset))

table.insert(jsonData.offset, tonumber(dlg.data.yoffset))

local filePath = ""

if dlg.data.confirm then
    if dlg.data.file_path then
        filePath = dlg.data.file_path
    end

    if filePath == "" then
        error("File path must not be empty.")
    end

    if dlg.data.merge_duplicates then
        local nextIndex = 1
        local seenFrames = {}
    
        for i = 1, #spr.frames do
            local realIdx = getFirstEqualFrame(i)
            if not seenFrames[realIdx] then
                seenFrames[realIdx] = nextIndex
                nextIndex = nextIndex + 1
            end
            deduplicatedFrames[i] = seenFrames[realIdx]
        end
    end

    for i,tag in ipairs(spr.tags) do

        if jsonData.animations[tag.name] == nil then
            jsonData.animations[tag.name] = {}
            jsonData.animations[tag.name].type = tag.repeats
            jsonData.animations[tag.name].directions = {}
        end
        
        local frames = {}
        
        if tag.aniDir == AniDir.FORWARD or tag.aniDir == AniDir.PING_PONG then
            for i=tag.fromFrame.frameNumber,tag.toFrame.frameNumber do
                buildFrame(frames, i)
            end
            if tag.aniDir == AniDir.PING_PONG then
                for i=tag.toFrame.frameNumber - 1,tag.fromFrame.frameNumber + 1,-1 do
                    buildFrame(frames, i)
                end
            end
        elseif tag.aniDir == AniDir.REVERSE or tag.aniDir == AniDir.PING_PONG_REVERSE then
            for i=tag.toFrame.frameNumber,tag.fromFrame.frameNumber,-1 do
                buildFrame(frames, i)
            end
            if tag.aniDir == AniDir.PING_PONG_REVERSE then
                for i=tag.fromFrame.frameNumber + 1,tag.toFrame.frameNumber - 1 do
                    buildFrame(frames, i)
                end
            end
        end
        
        if tag.data ~= "" then
            table.insert(frames, 1, tonumber(tag.data) / 1000)
        else
            table.insert(frames, 1, 0)
        end

        table.insert(jsonData.animations[tag.name].directions, frames)
        
    end

    local file = json.encode(jsonData)
    local myFilePath = filePath

    if pathChanged == false then
        myFilePath = app.fs.joinPath(fpath, filePath)
    end

    local newFile = io.open(myFilePath, "w")  -- "w" for writing mode
    newFile.write(newFile, file)
    newFile.close(newFile)

end