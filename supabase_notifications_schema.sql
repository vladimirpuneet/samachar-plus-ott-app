-- Supabase Notifications Table Schema
-- This table stores push notifications for users
-- Replaces Firebase Cloud Messaging (FCM) with Supabase Realtime

-- Create notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data JSONB DEFAULT '{}'::jsonb,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON public.notifications(read);
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON public.notifications(user_id, read) WHERE read = false;

-- Enable Row Level Security (RLS)
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- RLS Policies: Users can only see their own notifications
CREATE POLICY "Users can view their own notifications"
    ON public.notifications
    FOR SELECT
    USING (auth.uid() = user_id);

-- RLS Policies: Users can update their own notifications (mark as read)
CREATE POLICY "Users can update their own notifications"
    ON public.notifications
    FOR UPDATE
    USING (auth.uid() = user_id);

-- RLS Policies: Users can delete their own notifications
CREATE POLICY "Users can delete their own notifications"
    ON public.notifications
    FOR DELETE
    USING (auth.uid() = user_id);

-- RLS Policies: Service role can insert notifications for any user
CREATE POLICY "Service role can insert notifications"
    ON public.notifications
    FOR INSERT
    WITH CHECK (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON public.notifications
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Enable Realtime for notifications table
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.notifications TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.notifications TO service_role;

-- Comments for documentation
COMMENT ON TABLE public.notifications IS 'Stores push notifications for users. Replaces Firebase Cloud Messaging with Supabase Realtime.';
COMMENT ON COLUMN public.notifications.id IS 'Unique notification identifier';
COMMENT ON COLUMN public.notifications.user_id IS 'User who receives the notification';
COMMENT ON COLUMN public.notifications.title IS 'Notification title';
COMMENT ON COLUMN public.notifications.body IS 'Notification body/message';
COMMENT ON COLUMN public.notifications.data IS 'Additional notification data (JSON)';
COMMENT ON COLUMN public.notifications.read IS 'Whether the notification has been read';
COMMENT ON COLUMN public.notifications.created_at IS 'When the notification was created';
COMMENT ON COLUMN public.notifications.updated_at IS 'When the notification was last updated';
